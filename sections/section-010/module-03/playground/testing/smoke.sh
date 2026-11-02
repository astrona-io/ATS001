#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-03"
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

mkdir -p "$(dirname deployment-probe-canary.yaml)"
cat > deployment-probe-canary.yaml <<'CKAD_FILE_END'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-canary
  namespace: starfleet
spec:
  replicas: 1
  selector:
    matchLabels:
      app: probe
      release: probe-canary
  template:
    metadata:
      labels:
        app: probe
        release: probe-canary
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: canary
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
mkdir -p "$(dirname service-probe-shared.yaml)"
cat > service-probe-shared.yaml <<'CKAD_FILE_END'
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  selector:
    app: probe
  ports:
  - name: http
    port: 80
    targetPort: http
CKAD_FILE_END
kubectl apply -f deployment-probe-canary.yaml
kubectl -n starfleet rollout status deployment/probe-canary --timeout=120s
kubectl apply -f service-probe-shared.yaml
kubectl -n starfleet get endpointslice -l kubernetes.io/service-name=probe -o yaml
kubectl -n starfleet exec shuttle -- sh -c 'for attempt in 1 2 3 4 5 6 7 8 9 10; do wget -qO- http://probe/; done'
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe"}}}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
test "$(kubectl -n starfleet get svc probe -o jsonpath='{.spec.selector.release}')" = probe
printf 'ATS001/010/03: live practice checks passed\n'
