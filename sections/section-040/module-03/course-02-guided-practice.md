---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Install An Existing Chart And Inspect Effective Values

Helm installs a chart as a named release with selected values. You will use an existing versioned podinfo package, inspect its defaults and render it before installation. This package is separate from the probe fixture, so its release operations do not silently redefine the existing practice application.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-040/module-03/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-040-03)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-03"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Add the upstream podinfo chart repository and inspect the selected version. The version identifies a package input; the chart can still refer to image tags with their own identity contract.

```sh
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update podinfo
helm show values podinfo/podinfo --version 6.7.1
```

Inspect the supported values before choosing overrides. A key written in an arbitrary values file does not guarantee that a template uses it.

Save a values file, render the selected package, and install the named release. Wait for the supported workload rather than treating release record creation as application readiness.

Save this as `values-podinfo.yaml`:

```yaml
replicaCount: 1
```

Apply or use the saved input, then check the result:

```sh
helm template demo podinfo/podinfo --version 6.7.1 -n starfleet -f values-podinfo.yaml
helm upgrade --install demo podinfo/podinfo --version 6.7.1 -n starfleet -f values-podinfo.yaml --wait --timeout 3m
```

The rendered manifests show how the values affect resources. Installation additionally asks the target to realize those resources under current policy and capacity.

Inspect recorded values, rendered release resources and release metadata, then remove the release.

```sh
helm get values demo -n starfleet --all
helm get manifest demo -n starfleet
helm list -n starfleet
helm uninstall demo -n starfleet
```

Values, manifests and release status have different purposes. Uninstalling the package follows its resource lifecycle; it is not a general data-recovery operation.

Keep the chart version, release name, namespace and values together when explaining the result. A successful template render is not a live health check. Package downloads and image pulls also need network access, which is separate from understanding the chart contract.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
