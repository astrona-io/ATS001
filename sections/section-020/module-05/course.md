---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Revision History And Rollback

A new version of an application fails, and the team must return to a version that worked. A Deployment keeps a history of its Pod templates for this purpose. This module explains how revisions are created and stored, how to read them, and how to return to a chosen revision.

## Learning Goals

- Explain which changes create a revision and where a revision is stored.
- Read the revision history and the template of one revision.
- Record a reason for a change with the change-cause annotation.
- Roll back to the previous or to a named revision and state what a rollback does not restore.

## Before You Start

Use the module playground. It provides an isolated kind cluster with the `probe` Deployment and Service in the `starfleet` namespace.

## Reading Order

1. Recording And Reading Revision History
2. Rolling Back To A Chosen Revision
3. Roll Back To A Named Revision
4. Practise History And Rollback
5. Summary

<!-- astrona:playground -->
