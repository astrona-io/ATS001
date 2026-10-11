---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Rolling Updates And Availability

This module connects intended application behavior to declared resources and observed conditions.

## Learning Goals

- Identify changes that create Deployment revisions.
- Calculate surge and unavailability limits.
- Explain readiness and capacity effects on rollout.
- Distinguish reported progress failure from automatic recovery.

## Before You Start

Use the module playground for guided practice. It provides an isolated kind cluster and the declared starting fixtures. You need the Astrona command-line tool, kubectl and a working Podman engine; selected exercises also use Helm, curl or OpenSSL. Keep the module's private kubeconfig selected when running application commands.

## Reading Order

1. Rolling Updates And Health Gates
2. Calculating Rollout Capacity And Diagnosing Progress
3. Perform And Inspect A Rolling Template Update
4. Summary

The playground provides the initial state for the guided practice. Keep it open while following the practical steps.

<!-- astrona:playground -->
