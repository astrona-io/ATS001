---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Deployment Strategy, Scaling And Pause

Some releases must not run two versions at once, some need a larger number of replicas, and some need several changes applied as one rollout. A Deployment offers a strategy field, a scale command and a pause switch for these cases. This module explains each and how they interact.

## Learning Goals

- Compare the RollingUpdate and Recreate strategies and choose between them.
- Calculate maxSurge and maxUnavailable, including percentage rounding.
- Scale a Deployment and change its image from the command line.
- Pause a rollout, batch several changes and resume.

## Before You Start

Use the module playground. It provides an isolated kind cluster with a `relay` Deployment that has two replicas and an explicit RollingUpdate strategy.

## Reading Order

1. Choosing A Deployment Strategy
2. Pausing A Rollout To Batch Changes
3. Switch To Recreate And Scale With One Rollout
4. Practise Strategy, Scaling And Pause
5. Summary

<!-- astrona:playground -->
