#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-02"
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

mkdir -p "$(dirname deployment-probe-green.yaml)"
cat > deployment-probe-green.yaml <<'CKAD_FILE_END'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-green
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probe
      release: probe-green
  template:
    metadata:
      labels:
        app: probe
        release: probe-green
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: v2
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
kubectl apply -f deployment-probe-green.yaml
kubectl -n starfleet rollout status deployment/probe-green --timeout=120s
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe-green"}}}'
kubectl -n starfleet get endpointslice -l kubernetes.io/service-name=probe -o yaml
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q "version=v2"'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe"}}}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
test "$(kubectl -n starfleet get svc probe -o jsonpath='{.spec.selector.release}')" = probe
printf 'ATS001/010/02: live practice checks passed\n'
