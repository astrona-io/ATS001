---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Release Operations And Recovery Limits

This module connects intended application behavior to declared resources and observed conditions.

## Learning Goals

- Identify release history in the correct namespace.
- Evaluate upgrade value reuse and chart changes.
- Explain hooks, waiting and immutable-field constraints.
- Assess rollback and uninstall effects on external state.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Release History, Upgrades And Controlled Recovery
2. Upgrade A Release And Inspect Controlled Recovery
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
