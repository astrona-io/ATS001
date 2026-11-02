---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Existing Charts And Effective Values

Setting `replicaCount: 3` changes an application only if its chart template reads that value. Helm values are chart inputs, not Kubernetes fields. Tracing them into rendered resources prevents a plausible-looking override from being mistaken for an effective change.

## Learning Goals

- Distinguish chart, application and release identities.
- Trace value precedence into rendered fields.
- Review chart dependencies and resource requirements.
- Separate rendering, admission and application health.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Charts, Values And The Rendered Application
2. Install An Existing Chart And Inspect Effective Values
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
