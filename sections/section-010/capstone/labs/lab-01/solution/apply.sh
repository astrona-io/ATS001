#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-capstone-010" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
solution_directory="$lab_directory/solution"
kubectl apply -f "$solution_directory/deployment-probe-green.yaml"
kubectl apply -f "$solution_directory/deployment-relay-canary.yaml"
kubectl -n starfleet rollout status deployment/probe-green --timeout=180s
kubectl -n starfleet rollout status deployment/relay-canary --timeout=180s
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe-green"}}}'
