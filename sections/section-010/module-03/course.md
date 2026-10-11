---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Canary Exposure And Promotion

This module connects intended application behavior to declared resources and observed conditions.

## Learning Goals

- Explain shared Service selection for stable and canary Pods.
- Estimate exposure from ready endpoints with stated limits.
- Choose version-specific promotion evidence.
- Distinguish withdrawal from full release promotion.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Reasoning About Canary Traffic With Ordinary Services
2. Observe Canary Backends Without Assuming Exact Percentages
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
