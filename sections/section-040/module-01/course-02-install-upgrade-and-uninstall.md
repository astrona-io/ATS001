# Install, Upgrade And Uninstall

A release has a life: it is installed, upgraded, looked at, and finally removed. Helm keeps a numbered history of every step. This part takes the `study-web` chart through that whole life in the namespace `helm-lab`.

The commands below need the `study-web` chart saved in `charts/study-web/`, and are run from the folder that holds `charts/`.

## The task

Using the local chart in `charts/study-web`:

- Install release `study-web` in namespace `helm-lab` with `2` replicas.
- Upgrade it to image tag `1.32-alpine` and `3` replicas.
- Inspect release history and rendered values.
- Uninstall the release.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Install and upgrade

A chart template plus values produces Kubernetes manifests; release operations manage deployed revisions. `helm install` creates a new release; `helm upgrade` changes an existing one and adds a revision.

### Create the namespace and install

Create the namespace:

```bash
kubectl create namespace helm-lab
```

Install:

```bash
helm -n helm-lab install study-web charts/study-web --set replicaCount=2
```

Helm renders the templates with `replicaCount` set to `2` and creates the Deployment and the Service `study-web`. This is revision 1 of the release.

### Upgrade with new values

Upgrade:

```bash
helm -n helm-lab upgrade study-web charts/study-web \
  --set replicaCount=3 \
  --set image.tag=1.32-alpine
```

`helm upgrade` creates a new release revision. The new image tag changes the Deployment's pod template, so the Deployment rolls out new pods. When you pass any value on an upgrade, Helm starts again from the chart's defaults plus the values you pass now. Values from an earlier `--set` are dropped, so pass every value you still want each time (or add `--reuse-values`).

## Inspect the release

`helm history` is useful when debugging failed or unexpected chart updates. Read the release from both sides: what Helm recorded, and what is live in the cluster.

### Read the history, the values and the Deployment

Inspect:

```bash
helm -n helm-lab list
helm -n helm-lab history study-web
helm -n helm-lab get values study-web
kubectl -n helm-lab get deploy study-web -o wide
```

`helm list` shows the release and its current revision. `helm history` lists revision 1 (the install) and revision 2 (the upgrade). `helm get values` shows the values you set on the latest revision: `replicaCount` 3 and the `1.32-alpine` tag. `kubectl get deploy -o wide` shows the live Deployment with 3 replicas and the `nginx:1.32-alpine` image.

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Remove the release

The last step of the task clears the release away. One command removes everything Helm created for it.

### Uninstall

Uninstall:

```bash
helm -n helm-lab uninstall study-web
```

Helm deletes every object the release created, and the release itself. The chart files on your computer stay, so you can still check and render the chart:

```bash
helm lint charts/study-web
helm template study-web charts/study-web --set replicaCount=2
```

## When it does not work

- If Helm cannot find the chart, check your path from the folder that holds `charts/`.
- If replicas do not change, inspect values and rendered Deployment (`helm get values`, `helm template`).

> [!TIP]
> Always pass `-n <namespace>` to Helm, the same as to `kubectl`. A release lives in one namespace, and `helm list` without it looks only in the current one.

## Common pitfalls

> [!WARNING]
> - **Using `install` for a release that exists.** Helm refuses, because the name is taken. Use `upgrade`.
> - **Forgetting a value on upgrade.** If you pass any new value, the values from an earlier `--set` are dropped and the chart's defaults come back for them. Pass them again.
> - **Checking only Helm.** `helm list` saying `deployed` does not prove the pods are ready. Look at the Deployment too.
