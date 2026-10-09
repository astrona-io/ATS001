# Tidy Up The Releases On A Planet

This part is an exam-style task with four small Helm jobs on one planet, `birch`. Each job is one command, and each one acts on a release, not on Kubernetes objects.

The commands below need the chart repository `study-charts` added to Helm, with the address of your own training cluster's repository.

## The task

In namespace `birch`:

- Delete release `internal-issue-report-apiv1`.
- Upgrade release `internal-issue-report-apiv2` to a newer available version of chart `study-charts/nginx`.
- Install release `internal-issue-report-apache` from chart `study-charts/apache` with two replicas using Helm values.
- Find and delete a release stuck in `pending-install`.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

### Think it through

Before you look at the commands, answer these three questions:

- What namespace contains the release?
- Is the action install, upgrade, rollback, or uninstall?
- Which values does the chart actually support?

## Do the four jobs

The order below follows the task. Each command acts on one release in `birch`.

### Uninstall, upgrade, install, list

```bash
helm -n birch uninstall internal-issue-report-apiv1
helm search repo study-charts/nginx --versions
helm -n birch upgrade internal-issue-report-apiv2 study-charts/nginx
helm -n birch install internal-issue-report-apache study-charts/apache --set replicaCount=2
helm -n birch list --all
```

- `helm uninstall` removes the old release and its objects.
- `helm search repo ... --versions` lists every version of the chart in the repository, so you can see that a newer one exists.
- `helm upgrade` without `--version` moves the release to the newest chart version.
- `helm install ... --set replicaCount=2` creates the new release with two replicas. Use the value name that `helm show values` showed for this chart.
- `helm list --all` shows what is left, including any release stuck in `pending-install`.

### Remove the stuck release

Delete the stuck release after finding its name:

```bash
helm -n birch uninstall RELEASE_NAME
```

Replace `RELEASE_NAME` with the name `helm list --all` showed with the state `pending-install`.

## Prove the result

Use `kubectl get`, `kubectl describe`, JSONPath, logs, or events to prove the task is complete. For example, run `helm -n birch list --all` once more, and check the replica count of the new release's Deployment with `kubectl -n birch get deploy`.

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## When it does not work

- If a value does not work, inspect the chart default values.
- If a release is stuck, list all release states, not only deployed releases.

> [!TIP]
> Before an upgrade you are not sure about, add `--dry-run`. Helm renders the new revision and shows it, without changing the cluster.

## Common pitfalls

> [!WARNING]
> - **Deleting the Kubernetes objects instead of the release.** Helm still thinks the release exists. Use `helm uninstall`.
> - **Installing over an existing name.** `helm install` fails if the release name is taken; that is a job for `helm upgrade`.
> - **Forgetting `-n birch`.** Helm then looks in the current namespace and finds none of these releases.
