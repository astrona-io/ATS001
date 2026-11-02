#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-04"
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

kubectl -n starfleet set image deployment/probe probe=python:ckad-intentionally-missing
kubectl -n starfleet get deployment,replicasets,pods -l app=probe
kubectl -n starfleet describe deployment probe
kubectl -n starfleet describe pods -l app=probe
kubectl -n starfleet get events --sort-by=.metadata.creationTimestamp
kubectl -n starfleet rollout history deployment/probe
kubectl -n starfleet set image deployment/probe probe=docker.io/library/python:3.13-alpine
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
test "$(kubectl -n starfleet get deploy probe -o jsonpath='{.spec.template.spec.containers[0].image}')" = docker.io/library/python:3.13-alpine
printf 'ATS001/020/04: live practice checks passed\n'
