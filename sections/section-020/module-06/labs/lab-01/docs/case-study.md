---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Starting Environment

Deployment `relay` runs two replicas of version v1 with an explicit `RollingUpdate` strategy (`maxSurge: 1`, `maxUnavailable: 1`). Service `relay` selects its Pods.

Change Deployment `relay` to strategy type `Recreate`, three replicas and `VERSION` set to `v2`. The Deployment must not keep any `rollingUpdate` settings and must not stay paused. Wait until three replicas are updated, ready and available. The `shuttle` client must receive version v2 from Service `relay`.
