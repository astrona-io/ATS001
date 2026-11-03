---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Selectors, Ports And Endpoints When A Switch Fails

A blue-green switch changes one field on a Service, so it looks simple. In practice most failed switches come from three small mismatches: the selector matches no Pods, the matching Pods are not ready, or the Service sends traffic to a port where nothing listens. This part shows each failure on a live Service so you can recognise it from the evidence and repair it with the right command.

## How A Service Builds Its Backend List

A Service is an object with a stable virtual IP address and port. Its `spec.selector` is a map of labels. The EndpointSlice controller, which runs in the Kubernetes control plane, lists the Pods in the Service's namespace whose labels contain every pair in the selector. For each Pod that is ready, it writes the Pod IP address and port into an EndpointSlice object. The network implementation on each node reads those EndpointSlices and programs the rules that forward new connections.

A selector pair must match exactly, so `release: green` does not match `release: Green`. A Pod that is running but not ready stays in the EndpointSlice with its ready condition set to false, and the forwarding rules skip it. If no Pod matches, the Service still exists and has a cluster IP address, but it has no backend, and connections to it fail.

The port mapping has two fields. `port` is the port that clients use on the Service. `targetPort` is the port on the Pod where the container listens. It can be a number, or it can be the name of a container port such as `http`. A name has an advantage in a blue-green release: if version two listens on a different number but names the port `http`, the Service needs no change.

## Create A Service That Selects Nothing

Select the playground cluster first. The `probe` Service and its Deployment already exist in the `starfleet` namespace.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-02"
kubectl -n starfleet get service probe -o jsonpath='{.spec.selector}'
```

The command prints the selector map of the working Service. Now save a second Service that has two deliberate mistakes. Its selector names a release that no Pod carries, and its `targetPort` is a number where nothing listens.

Save this as `service-probe-broken.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe-broken
  namespace: starfleet
spec:
  selector:
    app: probe
    release: probe-green
  ports:
  - name: http
    port: 80
    targetPort: 9090
```

Apply it:

```sh
kubectl apply -f service-probe-broken.yaml
```

Then look at its backends:

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe-broken -o yaml
kubectl -n starfleet get pods -l app=probe --show-labels
```

The EndpointSlice for `probe-broken` lists no endpoint addresses, because no Pod carries `release: probe-green`. The Pod labels show the real values. Comparing the Service selector with the Pod labels is the first check for any switch that sends no traffic.

## Repair The Selector

The `kubectl set selector` command replaces the selector of a Service without editing YAML. Point `probe-broken` at the labels the running Pods really carry:

```sh
kubectl -n starfleet set selector service probe-broken app=probe,release=probe
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe-broken -o yaml
```

The EndpointSlice now lists the Pod addresses, and each endpoint reports its ready condition. The port in each endpoint is 9090, copied from the `targetPort`. The Pods are ready, so the Service looks healthy, yet the application listens on 8080.

Send a request from the `shuttle` client Pod and read the result:

```sh
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe-broken/
```

The request fails with a connection error, because the Pod accepts no connection on port 9090. This is the third failure: the selector and readiness are correct, but the port mapping is wrong. Fix it by using the container port name, then repeat the request:

```sh
kubectl -n starfleet patch service probe-broken --type=json -p '[{"op":"replace","path":"/spec/ports/0/targetPort","value":"http"}]'
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe-broken/
```

The second request returns the application's version line. Remove the practice Service before you continue, so it cannot select Pods of the next release:

```sh
kubectl -n starfleet delete service probe-broken
```

## Preview A Version Before The Switch

A preview Service gives a second, internal address to the new version, so you can test it before the public Service moves. The `kubectl expose` command creates a Service from a Deployment and copies the Deployment selector. You can print the object without creating it:

```sh
kubectl -n starfleet expose deployment probe --name=probe-preview --port=80 --target-port=http --dry-run=client -o yaml
```

The output is a Service named `probe-preview` whose selector equals the selector of Deployment `probe`. For a green Deployment you would run the same command against that Deployment, test through `probe-preview`, and only then change the selector of the public Service. The `--dry-run=client` flag asks kubectl to print the object and not send it to the cluster.

You now have the three checks for a failed switch: compare the selector with the Pod labels, read the ready conditions in the EndpointSlice, and compare `targetPort` with the container port. The next question is how a whole switch is performed and reverted in order, which the guided practice and the lab exercise.

## Common pitfalls

> [!WARNING]
> A Service with an empty backend list is accepted without any error. Always read the EndpointSlice after you change a selector or a port. Delete practice Services such as `probe-broken` when you finish, because a leftover Service can confuse later checks.
