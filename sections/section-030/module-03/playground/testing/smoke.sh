#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-03"
practice_directory="$(mktemp -d)"
cleanup() {
  if [[ -n "${PORT_FORWARD_PID:-}" ]]; then kill "$PORT_FORWARD_PID" 2>/dev/null || true; fi
  rm -rf "$practice_directory"
}
trap cleanup EXIT
cd "$practice_directory"
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}

mkdir -p base overlay
mkdir -p "$(dirname base/deployment-probe.yaml)"
cat > base/deployment-probe.yaml <<'CKAD_FILE_END'
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
        resources:
          requests:
            cpu: 10m
            memory: 32Mi
          limits:
            memory: 128Mi
        volumeMounts:
        - name: app
          mountPath: /app
          readOnly: true
      volumes:
      - name: app
        configMap:
          name: probe-code
CKAD_FILE_END
mkdir -p "$(dirname base/kustomization.yaml)"
cat > base/kustomization.yaml <<'CKAD_FILE_END'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
CKAD_FILE_END
mkdir -p "$(dirname overlay/patch-probe.yaml)"
cat > overlay/patch-probe.yaml <<'CKAD_FILE_END'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: probe
        env:
        - name: VERSION
          value: overlay
CKAD_FILE_END
mkdir -p "$(dirname overlay/kustomization.yaml)"
cat > overlay/kustomization.yaml <<'CKAD_FILE_END'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../base
patches:
- path: patch-probe.yaml
CKAD_FILE_END
kubectl kustomize overlay
kubectl apply -k overlay
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.replicas}{"\n"}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
kubectl apply -k base
kubectl -n starfleet rollout status deployment/probe --timeout=120s
test "$(kubectl -n starfleet get deploy probe -o jsonpath='{.spec.replicas}')" = 2
printf 'ATS001/030/03: live practice checks passed\n'
