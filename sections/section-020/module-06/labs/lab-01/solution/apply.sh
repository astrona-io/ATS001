#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-lab-020-06-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
solution_directory="$lab_directory/solution"
kubectl -n starfleet rollout pause deployment/relay
kubectl -n starfleet patch deployment relay --type=merge -p '{"spec":{"replicas":3,"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet set env deployment/relay VERSION=v2
kubectl -n starfleet rollout resume deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=180s
