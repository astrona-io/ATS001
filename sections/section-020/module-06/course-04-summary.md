---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Summary

A Deployment strategy decides how a template change reaches the Pods. RollingUpdate replaces Pods in steps and keeps old and new versions side by side. Recreate removes all old Pods first, so the versions never overlap and the application is briefly unavailable.

The fields maxSurge and maxUnavailable limit a rolling update. A percentage maxSurge rounds up, a percentage maxUnavailable rounds down, and both cannot be zero together. A Deployment that uses Recreate must not keep a rollingUpdate block.

Scaling changes the replica count and starts no rollout. Pausing stops template changes from starting rollouts, so several edits can become one rollout and one revision when the Deployment resumes. Restart rolls the Pods with a new annotation in the template and follows the strategy.

<!-- astrona:playground:destroy -->
