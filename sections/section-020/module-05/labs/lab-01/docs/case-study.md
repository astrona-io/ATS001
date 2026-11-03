---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Starting Environment

Deployment `probe` has gone through three revisions. Revision one runs version v1 and works. Revision two sets `VERSION` to v2 and works. Revision three points at an image tag that does not exist, so its new Pod cannot start. The two version-two Pods still serve requests.

Use the Deployment rollout history to return `probe` to the Pod template of revision one: image `docker.io/library/python:3.13-alpine` and `VERSION` set to `v1`. Wait until two replicas are updated, ready and available. Then set the annotation `kubernetes.io/change-cause` on Deployment `probe` to `rolled back to v1`. Do not delete the Deployment. The `shuttle` client must receive version v1.
