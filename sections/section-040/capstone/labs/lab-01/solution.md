---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Helm Section Capstone: Recover And Update A Release Solution

Select the lab's private kubeconfig.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-040-capstone-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-040-capstone-01" || exit 1
```

## Inspect and explain

Read the record first. The history shows revision 1 as superseded and revision 2 as deployed, and the supplied values show the mistaken version.

```sh
helm history crew -n starfleet
helm get values crew -n starfleet
helm list -n outpost
```

A rollback creates a new revision that copies revision 1, so the release moves to revision 3. A later upgrade makes revision 4. An upgrade without `--reuse-values` starts from the chart defaults and applies only the values you pass, so the values file must contain both settings.

```sh
helm rollback crew 1 -n starfleet --wait --timeout 3m
```

Save this as `crew-values.yaml`:

```yaml
replicaCount: 2
version: "v1.1"
```

Upgrade from the local chart and remove the unused release.

```sh
helm upgrade crew ./chart -n starfleet -f crew-values.yaml --wait --timeout 3m
helm uninstall scratch -n outpost
```

## Verify the result

```sh
helm history crew -n starfleet
helm get values crew -n starfleet
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://helm-probe/
helm list -n outpost
```

The history ends with the rollback entry and the upgrade, the values match the file and the response contains `version=v1.1`. After recording the result, remove this lab with `astrona destroy ats-001-lab-040-capstone-01`.

## Common pitfalls

> [!WARNING]
> Uninstalling the wrong release name or namespace deletes a running application. Check `helm list -A` before you run `helm uninstall`. Also quote `v1.1` in the values file so that it stays text.
