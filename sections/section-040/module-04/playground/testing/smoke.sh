#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-04"
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

helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update podinfo
helm upgrade --install demo podinfo/podinfo --version 6.7.1 -n starfleet --set replicaCount=1 --wait --timeout 3m
helm upgrade demo podinfo/podinfo --version 6.7.1 -n starfleet --set replicaCount=2 --wait --timeout 3m
helm history demo -n starfleet
kubectl -n starfleet get deployment -l app.kubernetes.io/instance=demo
helm rollback demo 1 -n starfleet --wait --timeout 3m
helm get values demo -n starfleet
helm uninstall demo -n starfleet
test -z "$(helm list -n starfleet -q --filter '^demo$')"
printf 'ATS001/040/04: live practice checks passed\n'
