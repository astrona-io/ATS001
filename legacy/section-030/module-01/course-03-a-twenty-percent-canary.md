# A Twenty Percent Canary

The same Kustomize layout works for a different target. This part builds the tree for the planet `tea-two`, where the canary must get 20 percent of the traffic: 10 total Pods.

## The task and the numbers

For `tea-two`: 10 total Pods, 20 percent traffic to canary. So set stable replicas to `8`, canary replicas to `2`, and make the Service select both stable and canary Pods by selecting only the shared app label.

The Service then has 10 equivalent endpoints, and 2 of them are canary pods: about 20% of the connections go to the canary.

## Write the base

The base for `tea-two` has the same three files as any Kustomize base, in the folder `tea-two/base/`.

### Save the base files

Save this as `tea-two/base/namespace.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: tea-two
```

Save this as `tea-two/base/app.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
  namespace: tea-two
spec:
  replicas: 5
  selector:
    matchLabels:
      app: tea
      track: stable
  template:
    metadata:
      labels:
        app: tea
        track: stable
    spec:
      containers:
        - name: nginx
          image: nginx:1-alpine
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea-canary
  namespace: tea-two
spec:
  replicas: 5
  selector:
    matchLabels:
      app: tea
      track: canary
  template:
    metadata:
      labels:
        app: tea
        track: canary
    spec:
      containers:
        - name: nginx
          image: nginx:1-alpine
---
apiVersion: v1
kind: Service
metadata:
  name: tea
  namespace: tea-two
spec:
  type: NodePort
  selector:
    app: tea
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30030
```

This base starts at 5 stable and 5 canary pods, a 50 percent canary, and opens `NodePort` `30030`.

Save this as `tea-two/base/kustomization.yaml`:

```yaml
resources:
  - namespace.yaml
  - app.yaml
```

## Write the prod overlay

The overlay only changes the counts. The Service patch keeps the selector at the shared label, so both tracks stay selected.

### Save the overlay files

Save this as `tea-two/overlays/prod/kustomization.yaml`:

```yaml
resources:
  - ../../base
patches:
  - path: patch.yaml
```

Save this as `tea-two/overlays/prod/patch.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
  namespace: tea-two
spec:
  replicas: 8
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea-canary
  namespace: tea-two
spec:
  replicas: 2
---
apiVersion: v1
kind: Service
metadata:
  name: tea
  namespace: tea-two
spec:
  selector:
    app: tea
```

## Render, apply and prove

Render first, then apply, then read the live pods.

### Render the overlay

```bash
kubectl kustomize tea-two/overlays/prod
```

Check that `tea` has `replicas: 8`, `tea-canary` has `replicas: 2`, and the Service selector is only `app: tea`.

### Apply and check

Apply it:

```bash
kubectl apply -k tea-two/overlays/prod
```

Then check the result:

```bash
kubectl -n tea-two get deploy,svc,pod --show-labels
```

You should see 8 pods with `track=stable` and 2 with `track=canary`, all with `app=tea`. If Service traffic percentage is wrong, check both replica counts and Service selectors.

> [!TIP]
> Before you apply a change to a live overlay, `kubectl diff -k <overlay>` shows what would change in the cluster, line by line.

## Common pitfalls

> [!WARNING]
> - **Only changing the canary count.** 2 canary pods next to 5 stable ones is about 29%, not 20%. Both counts set the share.
> - **Adding `track` to the selector.** Then the Service selects one track only, and the share is 0% or 100%.
> - **Running the commands from the wrong folder.** `kubectl apply -k tea-two/overlays/prod` is relative to the folder that holds `tea-two/`.
