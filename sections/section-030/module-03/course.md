---
draft: true
exam_objectives:
- Kustomize
---
# Focused Patches For Environment Changes

A patch should raise `probe` replicas without deleting its sidecar or changing which Pods the Deployment owns. A short patch is useful only when its merge behavior preserves those unrelated relationships.

## Learning Goals

- Select a clear owner for an environment setting.
- Choose a precise patch target.
- Compare schema-aware merge and ordered JSON operations.
- Detect unintended container or selector changes.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Targeted Patches And Environment Differences
2. Patch One Environment Without Editing Its Base
3. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
