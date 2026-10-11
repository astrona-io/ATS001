---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Diagnose A Failed Image Update And Repair The Template

This exercise creates an intentional image preparation failure. The invalid tag belongs to the practice workload, and the previous replicas remain useful evidence. You will locate the failure in Pod events and template history, then repair the managed template instead of repeatedly deleting Pods.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-020/module-04/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-04)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-04"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Select an intentionally unavailable image tag and inspect the Deployment and its new Pods. Do not wait indefinitely for a rollout that cannot fetch its image.

```sh
kubectl -n starfleet set image deployment/probe probe=python:ckad-intentionally-missing
kubectl -n starfleet get deployment,replicasets,pods -l app=probe
kubectl -n starfleet describe deployment probe
```

Pod creation is not image availability. Find the new Pod and examine its events; the exact event timing depends on the runtime and registry response.

Collect image and event evidence without assuming that an application process started. Logs can be absent when preparation failed before the process existed.

```sh
kubectl -n starfleet describe pods -l app=probe
kubectl -n starfleet get events --sort-by=.metadata.creationTimestamp
kubectl -n starfleet rollout history deployment/probe
```

Compare the desired image with the Pod status and event reason. Distinguish registry or image preparation from an application crash. Deleting the Pod would repeat the same bad template.

Repair the Deployment image and wait for actual rollout progress. The corrected template is the durable change.

```sh
kubectl -n starfleet set image deployment/probe probe=docker.io/library/python:3.13-alpine
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

A working request checks the application path after the repair. It does not retroactively prove why every earlier event occurred; retain the evidence used for your diagnosis.

This is a controlled failure in an isolated environment. The useful habit is to identify the first unsatisfied contract, repair authoritative input and observe recovery. Repeated restarts or broad unrelated changes make the cause harder to assess.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
