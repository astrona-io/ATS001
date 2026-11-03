---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Practise History And Rollback

This exercise breaks the `probe` Deployment on purpose, finds the last working revision from the history and returns to it. The scenario is that a version-three image tag was mistyped in `starfleet`, and the team needs the application back before they fix the tag.

<!-- astrona:playground:renew -->

Select the playground and record the starting point:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-05)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-05"
kubectl -n starfleet rollout history deployment/probe
```

Create a good second revision and then a broken third revision that uses an image tag that does not exist:

```sh
kubectl -n starfleet set env deployment/probe VERSION=v2
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet set image deployment/probe probe=docker.io/library/python:3.13-alpine-missing
kubectl -n starfleet get pods -l app=probe
```

The new Pod cannot pull its image, so it stays in an error state such as `ErrImagePull` or `ImagePullBackOff`, and the two version-two Pods keep serving requests. The rolling update stops because the new Pod never becomes ready. Show the history and compare revision three with revision two:

```sh
kubectl -n starfleet rollout history deployment/probe
kubectl -n starfleet rollout history deployment/probe --revision=3
```

The image in revision three is the missing tag. Roll back and annotate the cause:

```sh
kubectl -n starfleet rollout undo deployment/probe
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet annotate deployment/probe kubernetes.io/change-cause="rolled back from a bad image tag" --overwrite
kubectl -n starfleet get pods -l app=probe
```

The Pod with the bad image is gone and two ready Pods run version two. The undo went to revision two because revision three was the current one. A final request confirms the result:

```sh
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

## Common pitfalls

> [!WARNING]
> Do not delete the failed Pods to fix a failed rollout: the ReplicaSet creates them again with the same template. Change the template or roll back. Keep a note of which revision worked before you start another change.
