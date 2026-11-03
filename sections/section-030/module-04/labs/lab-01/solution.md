---
draft: true
exam_objectives:
- Kustomize
---
# Generate A ConfigMap With Kustomize Solution

Select the lab's private kubeconfig.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-04-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-04-01" || exit 1
```

## Inspect and explain

The running Deployment mounts only the application code. Check the current response and the volumes.

```sh
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.spec.volumes}{"\n"}'
kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

A `configMapGenerator` entry creates a ConfigMap during the build and adds a hash to its name. Kustomize rewrites the Deployment's reference to `probe-settings` so that it names the hashed ConfigMap. Because the Pod template changes, the Deployment rolls out new Pods.

Save the Deployment from the task as `base/deployment-probe.yaml`, then save this as `base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
namespace: starfleet
configMapGenerator:
- name: probe-settings
  literals:
  - greeting=hello-fleet
```

Render the build to check the names, then apply it.

```sh
kubectl kustomize base
kubectl apply -k base
```

## Verify the result

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

The response must contain `greeting=hello-fleet`. After recording the result, remove this lab with `astrona destroy ats-001-lab-030-04-01`.

## Common pitfalls

> [!WARNING]
> Do not set `disableNameSuffixHash`. The grader expects the hashed name. Also check that the volume mounts at `/settings`, because the application reads `/settings/greeting`.
