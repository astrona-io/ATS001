---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Summary

An Ingress maps an HTTP host and path to a Service and port. The Ingress controller, not the API server, turns those rules into routing, so an Ingress without a controller is stored but routes nothing.

A weighted canary uses two Ingress objects for the same host and path. The primary points to the stable Service. The canary points to the canary Service and carries controller-specific annotations that set a weight or a header rule. Annotation values are strings and the API server does not validate them.

Compared with a Service-only canary, an Ingress canary sets the share by annotation and does not depend on replica counts. Promotion still means updating the stable Deployment first and removing the canary second, and withdrawal means deleting or reducing the canary Ingress.

<!-- astrona:playground:destroy -->
