---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Release Diagnosis And Template History

This module connects intended application behavior to declared resources and observed conditions.

## Learning Goals

- Compare intended release identity with observed resources.
- Locate the failed transition in a release.
- Choose a correction supported by diagnostic evidence.
- Evaluate rollback limits and meaningful verification.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Intended Versions And Observed Progress
2. Reproduce, Correct And Verify
3. Diagnose A Failed Image Update And Repair The Template
4. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
