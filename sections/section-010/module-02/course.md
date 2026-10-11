---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# A Prepared Blue-Green Switch

This module connects intended application behavior to declared resources and observed conditions.

## Learning Goals

- Explain Service selection across two versions.
- Verify readiness, capacity and backend ports.
- Distinguish a traffic switch from a data migration.
- Evaluate the conditions for safe traffic rollback.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Switching Service Traffic Between Two Versions
2. Switch A Service Between Ready Versions
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
