#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-capstone-020" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
solution_directory="$lab_directory/solution"
kubectl -n starfleet rollout undo deployment/bridge
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
kubectl -n starfleet patch deployment scanner --type=merge -p '{"spec":{"replicas":3,"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet set env deployment/scanner VERSION=v3
kubectl -n starfleet rollout status deployment/scanner --timeout=180s
