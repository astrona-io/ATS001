# Section 020: Rolling Updates And Rollbacks

A Deployment changes its pods a few at a time, so the app keeps running while a new version comes in. Astronaut, this is how you swap a whole fleet for new ships without leaving the sky empty, and how you go back when the new ships fail their pre-flight check.

## Modules

| Module | What you learn | Graded mission |
| --- | --- | --- |
| [Roll Out A New Version Without Downtime](./module-01/course.md) | What starts a rollout, and how `maxSurge` and `maxUnavailable` set its pace | None yet |
| [Roll Back A Broken Rollout](./module-02/course.md) | Reading rollout history, and going back with `kubectl rollout undo` | None yet |

## What you need

A practice Kubernetes cluster (for example one made with `kind create cluster`) and `kubectl` set up to talk to it. Each module creates its own namespace and deletes it at the end.
