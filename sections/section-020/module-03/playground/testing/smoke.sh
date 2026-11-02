#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-03"
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

kubectl -n starfleet get deployment probe -o jsonpath='{.spec.strategy}{"\n"}'
kubectl -n starfleet get replicasets -l app=probe
kubectl -n starfleet set env deployment/probe VERSION=v2
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet get pods -l app=probe
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q "version=v2"'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
kubectl -n starfleet rollout undo deployment/probe
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
test "$(kubectl -n starfleet get deploy probe -o jsonpath='{.status.availableReplicas}')" = 2
printf 'ATS001/020/03: live practice checks passed\n'
