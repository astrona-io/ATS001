# Blue-Green Service Switch

This lab teaches the CKAD pattern for routing traffic between two Deployment versions by changing a Service selector.

Blue-green deployment keeps two versions of an application available at the same time:

- **blue** is the version that should receive user traffic
- **green** is the other version, often used for a new rollout, validation, or fallback

In Kubernetes, a Service does not point to a Deployment by name. A Service points to Pods by label selector. That is the key idea in this lab.

For the CKAD exam, remember this sentence:

> Services route to Pods through labels, not to Deployments directly.

## What You Learn

- How a Service selector chooses backend Pods
- How Deployment labels and Pod template labels relate to Service endpoints
- How to update one Deployment image with `kubectl set image`
- How to switch traffic by patching a Service selector
- How to verify traffic routing through endpoints

## Objects In This Lab

The starting resources are in `manifests/lab-start.yaml`.

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment `web-blue` | `venus` | Runs the blue version of the web app |
| Deployment `web-green` | `venus` | Runs the green version of the web app |
| Service `web-svc` | `venus` | Routes traffic to matching Pods |

The important labels are:

| Workload | Pod labels |
| --- | --- |
| `web-blue` | `app=web`, `version=blue` |
| `web-green` | `app=web`, `version=green` |

The Service starts with this selector:

```yaml
selector:
  app: web
```

That selector matches both blue and green Pods because both Deployments create Pods with `app=web`.

```text
Service web-svc
selector: app=web

  ├── matches Pods from web-blue   labels: app=web, version=blue
  └── matches Pods from web-green  labels: app=web, version=green
```

To route only to blue, the Service needs a more specific selector:

```yaml
selector:
  app: web
  version: blue
```

## Study First

Before running the solution commands, answer these questions:

1. Which object receives traffic from clients?
2. Does a Service select a Deployment name or Pod labels?
3. Which labels are shared by both versions?
4. Which label separates blue from green?
5. After the switch, should green Pods still exist?

Expected reasoning:

- The Service receives traffic.
- The Service selects Pods by labels.
- `app=web` is shared by both versions.
- `version=blue` and `version=green` separate the versions.
- Green Pods can still exist; they just should not receive traffic from this Service.

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory:

```bash
cd application-deployment/01-blue-green-service-switch
```

## Step 1: Create The Lab Resources

Apply the starting state:

```bash
kubectl apply -f manifests/lab-start.yaml
```

Check the Deployments and Service:

```bash
kubectl -n venus get deploy,svc
```

Wait for both Deployments:

```bash
kubectl -n venus rollout status deployment/web-blue
kubectl -n venus rollout status deployment/web-green
```

## Step 2: Inspect Labels Before Changing Anything

Always inspect labels before changing a Service selector.

```bash
kubectl -n venus get pods --show-labels
```

Expected label pattern:

```text
web-blue-...    app=web,version=blue
web-green-...   app=web,version=green
```

Now inspect the Service:

```bash
kubectl -n venus get service web-svc -o yaml
```

Focus on:

```yaml
spec:
  selector:
    app: web
```

This explains why the Service currently points to both application versions.

## Step 3: Check Current Endpoints

Endpoints show the actual backend Pod IPs selected by the Service.

```bash
kubectl -n venus get endpoints web-svc
```

You should see endpoints for both blue and green Pods. If endpoints are empty, the Service selector does not match any ready Pods.

For a more detailed view:

```bash
kubectl -n venus describe service web-svc
```

## Step 4: Update The Green Deployment Image

The task asks you to update only the green Deployment from `nginx:1.30-alpine` to `nginx:1.31-alpine`.

Use `kubectl set image`:

```bash
kubectl -n venus set image deployment/web-green nginx=nginx:1.31-alpine
```

Wait for the rollout:

```bash
kubectl -n venus rollout status deployment/web-green
```

Check the image:

```bash
kubectl -n venus get deployment web-green \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Expected output:

```text
nginx:1.31-alpine
```

Why this command works:

- `deployment/web-green` identifies the target Deployment
- `nginx=nginx:1.31-alpine` means "set the container named `nginx` to this image"
- changing the Pod template triggers a Deployment rollout

## Step 5: Switch The Service To Blue

Patch the Service selector so it matches only blue Pods:

```bash
kubectl -n venus patch service web-svc \
  -p '{"spec":{"selector":{"app":"web","version":"blue"}}}'
```

This changes:

```yaml
selector:
  app: web
```

to:

```yaml
selector:
  app: web
  version: blue
```

The Service now requires both labels to match. Green Pods have `app=web`, but they do not have `version=blue`, so they are no longer selected.

## Step 6: Verify The Traffic Switch

Check the Service selector:

```bash
kubectl -n venus get service web-svc \
  -o jsonpath='{.spec.selector}{"\n"}'
```

Expected output:

```text
{"app":"web","version":"blue"}
```

Check endpoints again:

```bash
kubectl -n venus get endpoints web-svc
```

The endpoint IPs should now belong only to blue Pods.

Compare with blue Pod IPs:

```bash
kubectl -n venus get pods -l app=web,version=blue -o wide
```

Compare with green Pod IPs:

```bash
kubectl -n venus get pods -l app=web,version=green -o wide
```

The Service endpoints should match the blue Pod IPs, not the green Pod IPs.

## Command Summary

```bash
kubectl apply -f manifests/lab-start.yaml

kubectl -n venus get pods --show-labels
kubectl -n venus get service web-svc -o yaml
kubectl -n venus get endpoints web-svc

kubectl -n venus set image deployment/web-green nginx=nginx:1.31-alpine
kubectl -n venus rollout status deployment/web-green

kubectl -n venus patch service web-svc \
  -p '{"spec":{"selector":{"app":"web","version":"blue"}}}'

kubectl -n venus get service web-svc \
  -o jsonpath='{.spec.selector}{"\n"}'
kubectl -n venus get endpoints web-svc
```

## Troubleshooting

### Service Has No Endpoints

Check selector and Pod labels:

```bash
kubectl -n venus get service web-svc -o jsonpath='{.spec.selector}{"\n"}'
kubectl -n venus get pods --show-labels
```

The Service selector must match labels on ready Pods. If even one selector key does not match, the Pod is excluded.

### Green Still Receives Traffic

Check whether the Service selector is still too broad:

```bash
kubectl -n venus get service web-svc -o yaml
```

If the selector is only `app=web`, it still matches both versions.

### Image Did Not Update

Check the container name:

```bash
kubectl -n venus get deployment web-green \
  -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

`kubectl set image` needs the correct container name on the left side of `=`.

## Common Mistakes

- Setting the Service selector to the Deployment name.
- Updating `web-blue` instead of `web-green`.
- Deleting `web-green` even though the task only asks to stop routing traffic to it.
- Forgetting that Service endpoints point to Pods, not ReplicaSets or Deployments.
- Patching labels on the Service metadata instead of `spec.selector`.

## Practice Variations

After you solve the lab once, repeat it with small changes:

1. Switch traffic to green instead of blue.
2. Scale `web-blue` to zero and observe what happens to `web-svc` endpoints.
3. Change the Service back to `app=web` and confirm it selects both versions.
4. Add a new label `track=stable` to blue Pods through the Deployment template and switch the Service to that label.
5. Use `kubectl edit service web-svc` instead of `kubectl patch`.

## Cleanup

Delete the lab namespace:

```bash
kubectl delete namespace venus
```

## CKAD Exam Notes

- Read Service tasks carefully. If the task says "point the Service to X", inspect labels before editing.
- `kubectl get endpoints SERVICE_NAME` is one of the fastest ways to verify Service routing.
- Do not assume labels from object names. Always check with `--show-labels`.
- If only one image needs changing, `kubectl set image` is usually faster than editing YAML.
- Service selector changes take effect quickly because the endpoints controller recalculates matching Pods.

## Related Commands

```bash
kubectl -n venus get pods --show-labels
kubectl -n venus get service web-svc -o yaml
kubectl -n venus describe service web-svc
kubectl -n venus get endpoints web-svc
kubectl -n venus set image deployment/web-green nginx=nginx:1.31-alpine
kubectl -n venus rollout status deployment/web-green
kubectl -n venus patch service web-svc -p '{"spec":{"selector":{"app":"web","version":"blue"}}}'
```

## References

- Kubernetes Services: https://kubernetes.io/docs/concepts/services-networking/service/
- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Managing resources with labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
