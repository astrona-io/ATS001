#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-05"
practice_directory="$(mktemp -d)"
cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then kill "$SERVER_PID" 2>/dev/null || true; fi
  helm repo remove local-crew >/dev/null 2>&1 || true
  helm uninstall crew -n starfleet >/dev/null 2>&1 || true
  rm -rf "$practice_directory"
}
trap cleanup EXIT
cd "$practice_directory"
mkdir -p crew-chart/templates repository
cat > crew-chart/Chart.yaml <<'FILE_END'
apiVersion: v2
name: crew-chart
version: 0.1.0
appVersion: v1
type: application
FILE_END
cat > crew-chart/values.yaml <<'FILE_END'
replicaCount: 1
version: v1
FILE_END
cat > crew-chart/templates/application.yaml <<'FILE_END'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crew-probe
  namespace: {{ .Release.Namespace }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: crew-probe
  template:
    metadata:
      labels:
        app: crew-probe
    spec:
      containers:
      - name: probe
        image: docker.io/library/busybox:1.37.0
        command: ["sh", "-c", "sleep 3600"]
        env:
        - name: VERSION
          value: {{ .Values.version | quote }}
FILE_END
helm lint crew-chart
helm package crew-chart --destination repository
helm repo index repository
python3 -m http.server 8879 --directory repository >/dev/null 2>&1 &
SERVER_PID=$!
sleep 2
helm repo add local-crew http://127.0.0.1:8879
helm repo update local-crew
helm search repo local-crew/crew-chart
helm show values local-crew/crew-chart
helm install crew local-crew/crew-chart -n starfleet --set replicaCount=2 --wait --timeout 3m
test "$(kubectl -n starfleet get deployment crew-probe -o jsonpath='{.spec.replicas}')" = 2
helm uninstall crew -n starfleet
printf 'ATS001/040/05: live practice checks passed\n'
