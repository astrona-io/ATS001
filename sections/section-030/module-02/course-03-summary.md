---
draft: true
exam_objectives:
- Kustomize
---
# Summary

Kustomize combines declared resource inputs and transformations into ordinary Kubernetes objects. Reusable bases and environment overlays express common behavior and intended differences.

Generated names can connect configuration identity to workload-template changes. Output still requires correct references, selectors and API support. Generating a Secret does not protect confidential inputs stored in an exposed source repository.

Client-side composition and cluster-side reconciliation are distinct operations. Generated object identity can create a template change through updated references, but correct rendering still requires compatible APIs and valid resource relationships.

<!-- astrona:playground:destroy -->
