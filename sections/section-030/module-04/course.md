---
draft: true
exam_objectives:
- Kustomize
---
# Generating ConfigMaps And Secrets With Kustomize

A team changes one line of application settings and applies the Deployment again. Kubernetes sees no change in the Pod template, so no Pod restarts and the application keeps the old settings. Kustomize generators solve this by giving each generated ConfigMap a name that depends on its content.

## Learning Goals

- Generate a ConfigMap and a Secret from literals, files and environment files.
- Explain the content hash in a generated name and how it starts a rollout.
- Choose between `create`, `merge` and `replace` behavior in an overlay.
- Turn off the hash suffix when a fixed name is required.

## Before You Start

You need to know what a ConfigMap and a Deployment are, and how a Pod mounts a ConfigMap as a volume. Use the module playground for the guided practice. It provides an isolated kind cluster with the `probe` application in the `starfleet` namespace.

## Reading Order

1. Generating ConfigMaps And Content Hashes
2. Secrets, Behavior And Generator Options
3. Generate Settings And Roll Them Out
4. Summary

<!-- astrona:playground -->
