#!/bin/bash
# bootstrap.sh - create k8s cluster and bootstraps GitOps applications using Flux CLI

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

./scripts/install-cli-tools.sh

echo
echo "Setup Kubernetes cluster ..."
if [ ! $(kind get clusters --quiet) ]; then
  kind create cluster --config kind-config.yaml --wait 1m
  kubectl wait node --all --for condition=ready
fi
kubectl cluster-info

echo
echo "Install Flux in cluster ..."
flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=flux-example \
  --branch=main \
  --path=./k8s/cluster \
  --personal

sleep 5s

./scripts/wait-for-sync.sh

./scripts/port-forward.sh

k6 run ./test/cluster-smoke-test.js

./scripts/next-steps.sh
