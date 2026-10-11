---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Perform And Inspect A Rolling Template Update

A Deployment rollout creates a new ReplicaSet when its Pod template changes. The playground gives you two ready replicas so you can observe a template update and its readiness gates. You will change an environment value, inspect strategy and revision evidence, then return to the previous template.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-020/module-03/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-03)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-03"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Inspect the configured rolling strategy and current ReplicaSets before changing the template. The strategy limits describe rollout capacity, while readiness determines whether a new replica is available.

```sh
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.strategy}{"\n"}'
kubectl -n starfleet get replicasets -l app=probe
```

Record the initial template and replica counts. Resource availability can affect whether a surge Pod starts, so a configured strategy is not proof of immediate progress.

Change VERSION in the Pod template and wait for the Deployment to report completion. This is a template update rather than an edit to one running container.

```sh
kubectl -n starfleet set env deployment/probe VERSION=v2
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet get pods -l app=probe
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q "version=v2"'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

Inspect new and old ReplicaSets after the operation. The response should identify v2 once ready endpoints have converged, but rollout completion does not prove every business operation is correct.

Return to the previous recorded template and observe the result.

```sh
kubectl -n starfleet rollout undo deployment/probe
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

Undo uses Deployment revision history. It restores a template under current conditions rather than restoring external data or a previous entire cluster state.

Compare template revision, available replicas and a fresh request together. These observations establish different parts of the release contract. A successful specification update is not sufficient when the new Pods fail readiness or the intended image cannot be obtained.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
