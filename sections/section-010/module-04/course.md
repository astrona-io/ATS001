---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Canary Routing With Ingress

A Service shares traffic by endpoint count, so it cannot send an exact small share to a new version. An Ingress controller routes at the HTTP layer and can split traffic by weight or by header. This module shows how two Services and two Ingress objects express a weighted canary, and what the cluster does and does not do with them.

## Learning Goals

- Describe how an Ingress routes a host and path to a Service.
- Create an Ingress from the command line and from YAML.
- Configure a canary Ingress with a weight and with a header.
- State which parts of a canary depend on the Ingress controller.

## Before You Start

Use the module playground. It provides an isolated kind cluster with a stable Service `probe` and a canary Service `probe-canary`. No Ingress controller is installed, so you inspect the objects and not live routing.

## Reading Order

1. Routing A Host To Two Services With Ingress
2. Canary Annotations And Their Limits
3. Create A Weighted Canary Ingress
4. Practise Canary Ingress Objects
5. Summary

<!-- astrona:playground -->
