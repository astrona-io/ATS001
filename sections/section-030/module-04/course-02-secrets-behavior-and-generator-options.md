---
draft: true
exam_objectives:
- Kustomize
---
# Secrets, Behavior And Generator Options

A base often defines default settings, and each overlay needs to change a few keys or replace the whole set. Some of the values are secrets. This part covers the `secretGenerator` field, the `behavior` setting that controls what an overlay does to a generated ConfigMap, and the options that change names and labels.

## Learning objectives

- Generate a Secret and explain how its values are stored.
- Use `behavior: merge` and `behavior: replace` in an overlay.
- Turn off the name hash with `disableNameSuffixHash`.

## The secretGenerator field

`secretGenerator` takes the same sources as `configMapGenerator`: `literals`, `files` and `envs`. It creates a Secret and base64-encodes each value into `data`. The default type is `Opaque`. A `type` field on the entry sets another type, such as `kubernetes.io/tls` or `kubernetes.io/dockerconfigjson`. The name gets a hash suffix in the same way.

Base64 is an encoding, not encryption. Anyone who can read the Secret or the kustomization file can read the value. Do not commit real credentials in a literal. For an exam task the file and literal forms are both acceptable.

## Behavior in an overlay

An overlay that lists a generator with the same name as a generator in the base must say what it wants. The `behavior` field has three values.

- `create` is the default. It creates a new object, and the build fails if the name already exists.
- `merge` keeps the base keys, adds new keys and overwrites keys that appear in both.
- `replace` discards the base content and uses only the overlay content.

<!-- astrona:playground:renew -->

Create two directories and save the base and an overlay.

```sh
mkdir -p merge-base merge-overlay
```

Save this as `merge-base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
configMapGenerator:
- name: crew-settings
  literals:
  - greeting=hello-fleet
  - mode=standard
```

Save this as `merge-overlay/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../merge-base
configMapGenerator:
- name: crew-settings
  behavior: merge
  literals:
  - mode=preview
secretGenerator:
- name: crew-token
  literals:
  - token=example-value
```

Render the overlay.

```sh
kubectl kustomize merge-overlay
```

Expected: the ConfigMap has `greeting: hello-fleet` from the base and `mode: preview` from the overlay. With `behavior: replace` instead, only `mode` would remain. A Secret named `crew-token-` plus a hash has `token` set to the base64 text of the literal.

## Options

An `options` block on a generator changes how the object is built.

- `disableNameSuffixHash: true` keeps the plain name. Use it when something outside the build refers to the exact name, but remember that a settings change then no longer starts a rollout.
- `labels` and `annotations` add metadata to the generated object only.
- `immutable: true` marks the ConfigMap or Secret as immutable, which fits the hashed names because their content never changes after creation.

A `namePrefix` or `namespace` in the kustomization applies to generated objects as well, and the references follow.

## Common pitfalls

> [!WARNING]
> Declaring the same generator name in an overlay without `behavior` fails the build with an ID conflict, because the default is `create`. Also, `behavior: merge` and `replace` need the base generator to be listed in a resource that the overlay includes, otherwise there is nothing to merge into.
