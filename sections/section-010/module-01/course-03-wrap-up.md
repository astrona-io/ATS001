# Wrap-Up: Mission Debrief

Well flown, astronaut. You can now swing a beacon from two fleets to one. Before you move on, look back at what you learned, check yourself, and make sure no lab is left running.

## What you learned

This module was about one idea: a Service picks its pods by label, so switching traffic means changing the selector.

**From [How A Service Finds Its Pods](./course-01-how-a-service-finds-its-pods.md):**

- Services route to Pods through labels, not to Deployments directly.
- A Deployment puts labels on its pods through its pod template. Here both versions share `app=web`, and `version=blue` or `version=green` tells them apart.
- A pod must carry every label in the selector. A selector of only `app: web` matches both versions.
- The endpoints are the list of ready pod addresses the Service sends traffic to. The endpoints controller keeps it up to date.
- Look first: `get pods --show-labels`, `get service -o yaml`, `get endpoints`, `describe service`.

**From [Update One Version And Switch The Traffic](./course-02-update-one-version-and-switch-traffic.md):**

- `kubectl set image deployment/<name> <container>=<image>` changes one Deployment's image and starts a rollout.
- `kubectl patch service` with a more specific selector switches all traffic to one version, within seconds.
- The other version keeps running; it just gets no traffic from the Service.
- Prove the switch with the selector, the endpoints and the pod addresses of each version.

## Your missions

You proved the switch in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Blue-Green Service Switch Lab](./labs/lab-01/README.md) | Update One Version And Switch The Traffic | update one version's image and switch a Service from both versions to the blue one |

If you skipped it, go back to it now. It takes about 15 minutes.

## Command summary

Every command from this module, in the order you use them in the mission:

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

The first line is how the starting state was made; in the graded lab, `astrona run` does it for you.

## Exam habits

- Read Service tasks carefully. If the task says "point the Service to X", inspect labels before editing.
- `kubectl get endpoints SERVICE_NAME` is one of the fastest ways to verify Service routing.
- Do not assume labels from object names. Always check with `--show-labels`.
- If only one image needs changing, `kubectl set image` is usually faster than editing YAML.
- Service selector changes take effect quickly because the endpoints controller recalculates matching Pods.

## Practice on your own

After you solve the lab once, start it again and repeat it with small changes:

1. Switch traffic to green instead of blue.
2. Scale `web-blue` to zero and observe what happens to `web-svc` endpoints.
3. Change the Service back to `app=web` and confirm it selects both versions.
4. Add a new label `track=stable` to blue Pods through the Deployment template and switch the Service to that label.
5. Use `kubectl edit service web-svc` instead of `kubectl patch`.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A Service's selector is <code>app: web</code>. Two Deployments make pods with <code>app=web</code>. Where does the traffic go?</summary>

To the ready pods of both Deployments. The selector matches every pod that carries `app=web`, whichever Deployment made it.
</details>

<details>
<summary>2. You patch the selector to <code>app: web, version: blue</code>. What happens to the green pods?</summary>

Nothing happens to the pods themselves: they keep running. They drop out of the Service's endpoints, so the Service sends them no more traffic.
</details>

<details>
<summary>3. <code>kubectl get endpoints</code> shows no addresses. What do you check?</summary>

Compare the Service selector with the pod labels (`--show-labels`). If one key does not match, or the pods are not ready, no pod is listed.
</details>

<details>
<summary>4. In <code>kubectl set image deployment/web-green nginx=nginx:1.31-alpine</code>, what is <code>nginx</code> on the left of the equals sign?</summary>

The name of the container inside the pod template. It must match exactly, or the command fails.
</details>

## Clean up

The graded lab is a whole Kubernetes cluster on your computer. When you are done, make sure none is left running.

First, see what is still running:

```sh
astrona list
```

If the list still shows the mission, remove it:

```sh
astrona destroy ast001-lab-010
```

If you practised on your own cluster instead, delete the lab namespace there:

```bash
kubectl delete namespace venus
```

> *A Service follows labels. Change the selector, and the beacon calls a different fleet.*
