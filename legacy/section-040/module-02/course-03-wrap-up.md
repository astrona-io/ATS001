# Wrap-Up: Mission Debrief

Well flown, astronaut. You tidied a whole planet of ship kits: an old one removed, one upgraded, a new one built to order, and a stuck one cleared. Before you move on, look back and check yourself.

## What you learned

This module was about acting on Helm releases, one command per job.

**From [Releases And Their States](./course-01-releases-and-their-states.md):**

- Helm actions operate on releases; Kubernetes objects are the rendered result.
- Each install or upgrade is a revision. States include `deployed`, `failed`, `superseded` and `pending-install`.
- `helm list --all` shows every state; a plain `helm list` hides `pending-install`.
- `helm repo add` and `helm repo update` connect a chart repository; `helm show values` shows what a chart lets you set.

**From [Tidy Up The Releases On A Planet](./course-02-tidy-up-the-releases-on-a-planet.md):**

- `helm uninstall` removes a release, `helm upgrade` moves it to a newer chart, `helm install --set` creates one with your values.
- `helm search repo <chart> --versions` shows which chart versions exist.
- A stuck release is found with `helm list --all` and removed with `helm uninstall`.

## Your missions

This module has no graded lab yet. Practise the steps on a cluster that has a chart repository, with the ideas below.

## Practice on your own

After you solve the task once, repeat it with one or two small changes so the skill becomes flexible:

- Run helm get manifest for a release.
- Use --dry-run before upgrade.
- Rollback to a previous revision.

## Exam habits

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A task mentions a release, but <code>helm list -n birch</code> does not show it. What do you try next?</summary>

`helm list -n birch --all`. A release stuck in `pending-install` only shows with `--all`.
</details>

<details>
<summary>2. How do you see which versions of <code>study-charts/nginx</code> exist?</summary>

`helm search repo study-charts/nginx --versions`.
</details>

<details>
<summary>3. You want two replicas, but you do not know the value name. What do you run?</summary>

`helm show values <chart>`, and look for a key such as `replicaCount` or `replicas`.
</details>

## Clean up

Remove the lab resources when finished. List what is left first:

```bash
helm -n birch list --all
```

Uninstall any release you created for practice with `helm -n birch uninstall <release>`.

> *Act on the release, and the objects follow.*
