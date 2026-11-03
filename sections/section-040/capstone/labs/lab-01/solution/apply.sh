#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-lab-040-capstone-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
work_directory="$(mktemp -d)"
trap 'rm -rf "$work_directory"' EXIT
printf 'replicaCount: 2\nversion: "v1.1"\n' > "$work_directory/crew-values.yaml"
helm rollback crew 1 -n starfleet --wait --timeout 3m
helm upgrade crew "$lab_directory/assets/chart" -n starfleet -f "$work_directory/crew-values.yaml" --wait --timeout 3m
helm uninstall scratch -n outpost
kubectl -n starfleet rollout status deployment/helm-probe --timeout=180s
