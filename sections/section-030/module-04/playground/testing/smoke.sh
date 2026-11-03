#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-04"
practice_directory="$(mktemp -d)"
trap 'rm -rf "$practice_directory"' EXIT
cd "$practice_directory"
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 2
  done
  return 1
}
mkdir -p base
cat > base/deployment-probe.yaml <<'FILE_END'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probe
      release: probe
  template:
    metadata:
      labels:
        app: probe
        release: probe
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: v1
        ports:
        - name: http
          containerPort: 8080
        readinessProbe:
          httpGet:
            path: /ready
            port: http
          periodSeconds: 2
        volumeMounts:
        - name: app
          mountPath: /app
          readOnly: true
        - name: settings
          mountPath: /settings
          readOnly: true
      volumes:
      - name: app
        configMap:
          name: probe-code
      - name: settings
        configMap:
          name: probe-settings
FILE_END
cat > base/kustomization.yaml <<'FILE_END'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
namespace: starfleet
configMapGenerator:
- name: probe-settings
  literals:
  - greeting=hello-fleet
FILE_END
kubectl kustomize base | grep -q 'name: probe-settings-'
kubectl apply -k base
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q greeting=hello-fleet'
sed -i.bak 's/hello-fleet/hello-again/' base/kustomization.yaml
kubectl apply -k base
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q greeting=hello-again'
test "$(kubectl -n starfleet get configmap -o name | grep -c probe-settings-)" -ge 2
printf 'ATS001/030/04: live practice checks passed\n'
