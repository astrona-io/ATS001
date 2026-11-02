#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-02"
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

mkdir -p probe-base
mkdir -p "$(dirname probe-base/deployment-probe.yaml)"
cat > probe-base/deployment-probe.yaml <<'CKAD_FILE_END'
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
mkdir -p "$(dirname probe-base/service-probe.yaml)"
cat > probe-base/service-probe.yaml <<'CKAD_FILE_END'
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  selector:
    app: probe
    release: probe
  ports:
  - name: http
    port: 80
    targetPort: http
CKAD_FILE_END
mkdir -p "$(dirname probe-base/kustomization.yaml)"
cat > probe-base/kustomization.yaml <<'CKAD_FILE_END'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
- service-probe.yaml
namePrefix: dev-
CKAD_FILE_END
kubectl kustomize probe-base
kubectl apply -k probe-base
kubectl -n starfleet rollout status deployment/dev-probe --timeout=120s
kubectl -n starfleet get deployment dev-probe -o yaml
kubectl delete -k probe-base
kubectl -n starfleet get deployment probe
test "$(kubectl -n starfleet get deploy probe -o jsonpath='{.status.availableReplicas}')" = 2
printf 'ATS001/030/02: live practice checks passed\n'
