---
estimated_duration: 15m
---

# Question

Solve this question on: `terminal`

Astronaut, two fleets of the same web app fly on the planet (namespace) `venus`. One is the blue fleet, the other the green fleet. Right now the beacon (the Service `web-svc`) sends signals to both of them. Mission control wants all traffic on blue, and the green fleet updated and kept ready as a fallback.

What is on the planet `venus`:

* `web-blue`: a Deployment with 2 replicas. Its pods carry the labels `app=web` and `version=blue`. The container is named `nginx` and runs `nginx:1.31-alpine`.
* `web-green`: a Deployment with 2 replicas. Its pods carry the labels `app=web` and `version=green`. The container is named `nginx` and runs `nginx:1.30-alpine`.
* `web-svc`: a Service on port `80`. Its selector is only `app: web`, so it matches the pods of both Deployments.

**Time:** about 15 minutes. **Topic:** blue-green deployment.

In the namespace `venus`:

1.  Update only the `web-green` Deployment so its `nginx` container runs the image `nginx:1.31-alpine`.
2.  Change the Service `web-svc` so it sends traffic only to the blue pods.

Keep to these rules:

* Do not delete `web-green` or its pods. Green stays ready; it just gets no traffic from `web-svc`.
* Do not delete and recreate the Service `web-svc`.
* Do not change `web-blue`.

You are done when:

* `kubectl -n venus get endpoints web-svc` lists only the IP addresses of the blue pods.
* `astrona submit` reports every check as passed. The grader checks two things on the live cluster: the Service `web-svc` exists in `venus`, and its selector has `version: blue`. The grader does not check the `web-green` image, so check that step yourself.
