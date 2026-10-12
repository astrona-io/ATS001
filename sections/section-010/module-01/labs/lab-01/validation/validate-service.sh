#!/usr/bin/env bash
set -euo pipefail

VALUE=$(kubectl get svc web-svc -n venus -o jsonpath='{.spec.selector.version}')

if [ "$VALUE" != "blue" ]; then
  echo "expected blue spec.selector.version to be 'blue', got '$VALUE'"
  exit 1
fi

echo "web-svc spec.selector.version content verified"
