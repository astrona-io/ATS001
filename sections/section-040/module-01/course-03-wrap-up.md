# Wrap-Up: Mission Debrief

Well flown, astronaut. You built a ship kit, launched it with your own options, upgraded it and cleared it away. Before you move on, look back, check yourself, and make sure nothing is left on the planet `helm-lab`.

## What you learned

This module was about a chart, its values, and the life of a release.

**From [What A Chart Is](./course-01-what-a-chart-is.md):**

- A chart has `Chart.yaml`, a `templates/` folder and `values.yaml`.
- Templates have blanks like `{{ .Values.replicaCount }}`; values fill them, from `values.yaml` or `--set`.
- `helm lint` checks a chart; `helm template` prints what it would create, without touching the cluster.

**From [Install, Upgrade And Uninstall](./course-02-install-upgrade-and-uninstall.md):**

- `helm install` creates a release; `helm upgrade` adds a revision.
- `helm list`, `helm history` and `helm get values` read the release; `kubectl` reads the live objects.
- `helm uninstall` removes the release and everything it created.

## Your missions

This module has no graded lab yet. Practise the steps on your own cluster with the ideas below.

## Practice on your own

After you solve the task once, repeat it with one or two small changes so the skill becomes flexible:

- Render the chart with helm template only.
- Add a chart value for Service type.
- Rollback the release after upgrade.

## Exam habits

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Where does the number of replicas in the <code>study-web</code> Deployment come from?</summary>

From the value `replicaCount`: the default is `1` in `values.yaml`, and `--set replicaCount=...` overrides it.
</details>

<details>
<summary>2. After one install and one upgrade, how many revisions does <code>helm history</code> show?</summary>

Two: revision 1 for the install and revision 2 for the upgrade.
</details>

<details>
<summary>3. What is the difference between <code>helm template</code> and <code>helm install</code>?</summary>

`helm template` only prints the rendered YAML. `helm install` renders it, sends it to the cluster and records a release.
</details>

## Clean up

Remove the lab resources when finished:

```bash
helm -n helm-lab uninstall study-web && kubectl delete namespace helm-lab
```

If you already uninstalled the release, only the namespace is left: `kubectl delete namespace helm-lab`.

> *Helm values feed templates; upgrades create release revisions.*
