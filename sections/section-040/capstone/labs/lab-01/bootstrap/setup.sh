#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-lab-040-capstone-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
kubectl apply -f "$lab_directory/bootstrap/manifests/start.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=120s
kubectl -n outpost wait --for=condition=Ready pod/drifter --timeout=120s
helm install crew "$lab_directory/assets/chart" -n starfleet --set replicaCount=1 --set version=v1 --wait --timeout 3m
helm upgrade crew "$lab_directory/assets/chart" -n starfleet --set replicaCount=1 --set version=v2 --wait --timeout 3m
helm install scratch "$lab_directory/assets/chart" -n outpost --set replicaCount=1 --set version=v1
