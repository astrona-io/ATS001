#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-lab-040-05-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
work_directory="$(mktemp -d)"
trap 'rm -rf "$work_directory"' EXIT
helm package "$lab_directory/solution/chart" --destination "$work_directory"
printf 'replicaCount: 3\nversion: v2\n' > "$work_directory/fleet-values.yaml"
helm install fleet "$work_directory/fleet-chart-0.2.0.tgz" -n starfleet -f "$work_directory/fleet-values.yaml" --wait --timeout 3m
kubectl -n starfleet rollout status deployment/fleet-probe --timeout=180s
