# Solution Walkthrough

Mission debrief, astronaut. The key idea of this lab fits in one sentence: **a Service sends traffic to pods through their labels, not to Deployments by name.** This walkthrough looks at the labels first, updates the green fleet, then swings the beacon to blue and proves it.

---

## Step 1: Start the lab

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS001.git -c sections/section-010/module-01/labs/lab-01
```

The `astrona` tool builds a small Kubernetes cluster and applies the lab's starting state, the same file as `kubectl apply -f manifests/lab-start.yaml`. Check the Deployments and the Service:

```sh
kubectl -n venus get deploy,svc
```

Wait for both Deployments to finish starting:

```sh
kubectl -n venus rollout status deployment/web-blue
kubectl -n venus rollout status deployment/web-green
```

## Step 2: Look at the labels before you change anything

Labels are the markings painted on each ship's hull. Always read them before you change a Service selector:

```sh
kubectl -n venus get pods --show-labels
```

You should see this label pattern (the pod names end in different letters on your cluster):

```text
web-blue-...    app=web,version=blue
web-green-...   app=web,version=green
```

Now look at the Service:

```sh
kubectl -n venus get service web-svc -o yaml
```

Find the selector:

```yaml
spec:
  selector:
    app: web
```

Both fleets carry `app=web`, so this selector matches all four pods. That is why the Service sends traffic to both versions.

## Step 3: Check the current endpoints

The endpoints are the beacon's list of pod addresses that answer it. The endpoints controller in Kubernetes keeps this list up to date from the selector:

```sh
kubectl -n venus get endpoints web-svc
```

You should see the addresses of both the blue and the green pods. If the list is empty, the selector matches no ready pod. For more detail:

```sh
kubectl -n venus describe service web-svc
```

## Step 4: Update the green Deployment's image

The task asks you to move only `web-green` from `nginx:1.30-alpine` to `nginx:1.31-alpine`:

```sh
kubectl -n venus set image deployment/web-green nginx=nginx:1.31-alpine
```

Here `deployment/web-green` names the target, and `nginx=nginx:1.31-alpine` means "set the container named `nginx` to this image". Changing the pod template makes the Deployment start a rollout. Wait for it:

```sh
kubectl -n venus rollout status deployment/web-green
```

Check the image:

```sh
kubectl -n venus get deployment web-green \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Expected output:

```text
nginx:1.31-alpine
```

## Step 5: Switch the Service to blue

Patch the selector so it matches only blue pods:

```sh
kubectl -n venus patch service web-svc \
  -p '{"spec":{"selector":{"app":"web","version":"blue"}}}'
```

This changes the selector from:

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

A pod must now carry both labels to be selected. Green pods have `app=web` but not `version=blue`, so the Service drops them. The green pods keep running; they just get no traffic from `web-svc`.

## Step 6: Prove the switch

Check the selector:

```sh
kubectl -n venus get service web-svc \
  -o jsonpath='{.spec.selector}{"\n"}'
```

Expected output:

```text
{"app":"web","version":"blue"}
```

Check the endpoints again:

```sh
kubectl -n venus get endpoints web-svc
```

Compare them with the blue and the green pod addresses:

```sh
kubectl -n venus get pods -l app=web,version=blue -o wide
kubectl -n venus get pods -l app=web,version=green -o wide
```

The Service's endpoints should match the blue pod addresses, not the green ones.

## Step 7: Submit your response

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```

The grader checks that `web-svc` exists in `venus` and that its selector has `version: blue`. It does not check the `web-green` image; you proved that yourself in Step 4.

## Step 8: Clean up

```sh
astrona destroy ast001-lab-010
```

## If something goes wrong

- **The Service has no endpoints.** Compare the selector with the pod labels (`kubectl -n venus get service web-svc -o jsonpath='{.spec.selector}{"\n"}'` and `kubectl -n venus get pods --show-labels`). If even one selector key does not match, the pod is left out.
- **Green still gets traffic.** The selector is probably still only `app=web`. Check it with `kubectl -n venus get service web-svc -o yaml`.
- **The image did not change.** `kubectl set image` needs the right container name on the left of `=`. Read it with `kubectl -n venus get deployment web-green -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'`.
