#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-001-capstone-020" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
kubectl apply -f "$lab_directory/bootstrap/manifests/start.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
kubectl -n starfleet rollout status deployment/scanner --timeout=180s
kubectl -n starfleet set env deployment/bridge VERSION=v2
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
kubectl -n starfleet set image deployment/bridge probe=docker.io/library/python:3.13-alpine-missing
kubectl -n starfleet wait --for=jsonpath='{.status.availableReplicas}'=2 deployment/bridge --timeout=60s
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=120s
kubectl -n outpost wait --for=condition=Ready pod/drifter --timeout=120s
