---
draft: true
exam_objectives:
- Kustomize
---
# Kustomize Section Capstone: Production Overlay Solution

Select the lab's private kubeconfig and save the two base files from the task.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-capstone-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-capstone-01" || exit 1
```

## Inspect and explain

Four changes are needed. A JSON 6902 patch with a `target` replaces the replica count and the `VERSION` value and appends the volume and the mount. A `configMapGenerator` entry creates the settings ConfigMap, and Kustomize rewrites the volume's reference to the hashed name. The `labels` field with `includeTemplates: true` adds the label to Pod templates, and the default `includeSelectors: false` keeps the selector unchanged, which matters because a selector cannot change on a live Deployment.

Save this as `production/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../base
configMapGenerator:
- name: probe-settings
  literals:
  - greeting=hello-production
labels:
- pairs:
    tier: production
  includeTemplates: true
patches:
- target:
    kind: Deployment
    name: probe
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 3
    - op: replace
      path: /spec/template/spec/containers/0/env/0/value
      value: v2
    - op: add
      path: /spec/template/spec/volumes/-
      value:
        name: settings
        configMap:
          name: probe-settings
    - op: add
      path: /spec/template/spec/containers/0/volumeMounts/-
      value:
        name: settings
        mountPath: /settings
        readOnly: true
```

The path `/spec/template/spec/containers/0/env/0/value` uses positions, which work here because the base has one container with `VERSION` as its first variable. Render, then apply.

```sh
kubectl kustomize production
kubectl apply -k production
```

## Verify the result

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

The response must contain `version=v2` and `greeting=hello-production`. After recording the result, remove this lab with `astrona destroy ats-001-lab-030-capstone-01`.

## Common pitfalls

> [!WARNING]
> A `commonLabels` field would add the label to the selector and the update would be rejected. If the build fails with a path error, compare the patch path with the rendered base.
