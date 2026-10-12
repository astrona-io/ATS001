---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Upgrade A Release And Inspect Controlled Recovery

A Helm release keeps revision metadata that can support selected configuration recovery. You will install a versioned package, change one supported value, inspect revision history and return to the earlier release configuration. The exercise keeps the package version fixed so the value change is easier to assess.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

Read the release namespace before interpreting its history. A revision identifies recorded chart and configuration state, while live resource status describes what the cluster currently realizes. The application may also have changed external state through a migration or a lifecycle hook.

Before recovery, identify which boundary needs restoration. Rolling back templates is appropriate only when the earlier application still works with current data and configuration. Check the installed Helm version's help for its supported options instead of assuming another version's failure-handling behavior.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-040/module-04/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-040-04)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-04"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Install the existing podinfo package with one replica. The explicit namespace and release name identify the release whose history you will inspect.

```sh
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update podinfo
helm upgrade --install demo podinfo/podinfo --version 6.7.1 -n starfleet --set replicaCount=1 --wait --timeout 3m
```

A release name is scoped to its namespace. The chart version and chosen values are independent inputs that should remain identifiable.

Change the replica value and inspect both recorded history and resulting Deployments.

```sh
helm upgrade demo podinfo/podinfo --version 6.7.1 -n starfleet --set replicaCount=2 --wait --timeout 3m
helm history demo -n starfleet
kubectl -n starfleet get deployment -l app.kubernetes.io/instance=demo
```

A new revision records the release operation. Deployment availability is a later target outcome, not a property inferred only from the history table.

Return to revision one, inspect the values and then uninstall the practice release.

```sh
helm rollback demo 1 -n starfleet --wait --timeout 3m
helm get values demo -n starfleet
helm uninstall demo -n starfleet
```

Rollback selects an earlier release configuration. It does not reverse arbitrary database migrations, messages or other external effects.

Use history to identify what is being restored and target evidence to assess the result. A historical revision can be incompatible with current data or unavailable artifacts. This isolated package exercise establishes release mechanics without claiming universal recovery safety.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
