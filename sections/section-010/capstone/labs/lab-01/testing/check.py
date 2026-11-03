#!/usr/bin/env python3
"""Read resource fields and run bounded behavior checks in one lab context."""
import json
import subprocess
import sys
import time

CONTEXT = "kind-astro-ats-001-capstone-010"


def run(args):
    return subprocess.run(args, capture_output=True, text=True, timeout=30)


def kubectl(*args):
    result = run(["kubectl", *args])
    assert result.returncode == 0, "Required command failed: kubectl " + " ".join(args[:4])
    return result.stdout.strip()


def get(kind, name, namespace="starfleet"):
    return json.loads(kubectl("-n", namespace, "get", kind, name, "-o", "json"))


def container(deployment):
    return deployment["spec"]["template"]["spec"]["containers"][0]


def env_value(deployment, key):
    for item in container(deployment).get("env", []):
        if item["name"] == key:
            return item.get("value")
    return None


def assert_available(name, replicas):
    deployment = get("deployment", name)
    status = deployment.get("status", {})
    assert deployment["spec"].get("replicas") == replicas, name + ": wrong replica count"
    assert status.get("observedGeneration", 0) >= deployment["metadata"]["generation"], name + ": newest generation not observed"
    for field in ("replicas", "updatedReplicas", "readyReplicas", "availableReplicas"):
        assert status.get(field, 0) == replicas, name + ": rollout is not complete"
    return deployment


def request(url, expected, pod="shuttle", namespace="starfleet"):
    """Retry a request for a bounded time because endpoint updates take a moment."""
    last = ""
    for _ in range(15):
        result = run(["kubectl", "-n", namespace, "exec", pod, "--", "wget", "-q", "-T", "3", "-O-", url])
        last = result.stdout
        if result.returncode == 0 and expected in last:
            return
        time.sleep(2)
    raise AssertionError("Request to " + url + " did not return " + expected)


def ready_endpoints(service):
    data = json.loads(kubectl("-n", "starfleet", "get", "endpointslices", "-l", "kubernetes.io/service-name=" + service, "-o", "json"))
    return [e for item in data["items"] for e in item.get("endpoints", []) if e.get("conditions", {}).get("ready") is True]


def main():
    assert kubectl("config", "current-context") == CONTEXT, "Refusing to operate on another Kubernetes context"
    assert_available("probe", 2)
    green = assert_available("probe-green", 2)
    assert env_value(green, "VERSION") == "v2", "probe-green must run version v2"
    service = get("service", "probe")
    assert service["spec"]["selector"] == {"app": "probe", "release": "probe-green"}, "Service probe must select only the green release"
    port = service["spec"]["ports"][0]
    assert port["port"] == 80 and port["targetPort"] == "http", "Keep port 80 and target port http"
    request("http://probe/", "version=v2 host=probe-green-")
    stable = assert_available("relay-stable", 3)
    assert env_value(stable, "VERSION") == "v1", "relay-stable must stay on v1"
    canary = assert_available("relay-canary", 1)
    assert env_value(canary, "VERSION") == "v2", "relay-canary must run version v2"
    assert get("service", "relay")["spec"]["selector"] == {"app": "relay"}, "Service relay must keep selecting only app: relay"
    assert len(ready_endpoints("relay")) == 4, "Service relay must have four ready endpoints"
    request("http://relay/", "version=")
    print("Required resource contract and behavior verified")


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, KeyError, ValueError, IndexError, subprocess.SubprocessError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
