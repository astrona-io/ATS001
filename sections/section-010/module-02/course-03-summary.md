---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Summary

Blue-green routing keeps distinct backend sets and selects the intended active version. The replacement set must be ready, sufficiently provisioned and compatible with the Service port contract.

Traffic selection changes do not move application state or instantly replace every established connection. Returning to an earlier backend set is useful only while that version remains available and compatible with current data.

A complete switch check compares the selected version, ready backend addresses and meaningful responses. The EndpointSlice controller updates backend membership, while the network implementation updates the rules used by client connections.

<!-- astrona:playground:destroy -->
