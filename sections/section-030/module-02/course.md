---
draft: true
exam_objectives:
- Kustomize
---
# Reusable Kustomize Composition

A development Deployment needs one replica while production needs several, but their container and Service definitions should stay consistent. Kustomize lets a shared base hold those common objects and lets each overlay express the intended difference.

## Learning Goals

- Explain a base, overlay and resource composition.
- Trace naming and namespace transformations.
- Explain generated configuration references and hashes.
- Review final selectors and supported API definitions.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Composing Resources With Kustomize
2. Render And Apply A Self-Contained Kustomize Base
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
