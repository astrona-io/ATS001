---
draft: true
exam_objectives:
- Kustomize
---
# Summary

A Kustomize generator creates a ConfigMap or a Secret during the build from literals, files or environment files. The generated name ends with a hash of the content, and Kustomize rewrites the references to that name in the same build.

Because the hashed name is part of the Pod template, a change in settings changes the template and starts a normal rolling update. The old ConfigMap stays in the cluster after an apply, which keeps rollback possible, and it must be cleaned up separately.

In an overlay, `behavior: merge` combines keys with the base, `behavior: replace` discards the base keys, and the default `create` fails when the name already exists. The option `disableNameSuffixHash` keeps a fixed name but removes the automatic rollout. Secret values are only base64 encoded, so the generator does not protect them.

<!-- astrona:playground:destroy -->
