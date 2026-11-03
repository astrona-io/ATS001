#!/usr/bin/env python3
"""Read resource fields and run bounded behavior checks in one lab context."""
import json
import subprocess
import sys
import time

CONTEXT = "kind-astro-ats-001-lab-020-05-01"


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
    deployment = assert_available("probe", 2)
    assert container(deployment)["image"] == "docker.io/library/python:3.13-alpine", "The image must be the working image"
    assert env_value(deployment, "VERSION") == "v1", "VERSION must be v1 again"
    assert deployment["metadata"].get("annotations", {}).get("kubernetes.io/change-cause") == "rolled back to v1", "Set the change-cause annotation to: rolled back to v1"
    assert deployment["spec"].get("paused") is not True, "The Deployment must not be paused"
    request("http://probe/", "version=v1")
    print("Required resource contract and behavior verified")


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, KeyError, ValueError, IndexError, subprocess.SubprocessError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
