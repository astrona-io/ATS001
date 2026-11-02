#!/usr/bin/env bash
set -euo pipefail
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-03"
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
helm show values podinfo/podinfo --version 6.7.1
mkdir -p "$(dirname values-podinfo.yaml)"
cat > values-podinfo.yaml <<'CKAD_FILE_END'
replicaCount: 1
CKAD_FILE_END
helm template demo podinfo/podinfo --version 6.7.1 -n starfleet -f values-podinfo.yaml
helm upgrade --install demo podinfo/podinfo --version 6.7.1 -n starfleet -f values-podinfo.yaml --wait --timeout 3m
helm get values demo -n starfleet --all
helm get manifest demo -n starfleet
helm list -n starfleet
helm uninstall demo -n starfleet
test -z "$(helm list -n starfleet -q --filter '^demo$')"
printf 'ATS001/040/03: live practice checks passed\n'
