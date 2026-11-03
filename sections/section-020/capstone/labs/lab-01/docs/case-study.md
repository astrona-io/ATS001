---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Starting Environment

Deployment `bridge` has three revisions. Revision one (v1) and revision two (`VERSION` v2) work. Revision three uses an image tag that does not exist, so its new Pod cannot start. Deployment `scanner` runs two replicas of v1 with an explicit `RollingUpdate` strategy.

Return `bridge` to its last working revision (version v2 with the image `docker.io/library/python:3.13-alpine`) and wait for two available replicas. Change Deployment `scanner` to strategy type `Recreate` with no `rollingUpdate` settings, three replicas and `VERSION` set to `v3`, and wait for three available replicas. The `shuttle` client must receive version v2 from Service `bridge` and version v3 from Service `scanner`.
