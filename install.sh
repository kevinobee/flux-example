#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications using Flux CLI

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
docker network inspect -f '{{json .IPAM.Config}}' kind

echo
echo "Install Flux in cluster ..."
flux check --pre
flux install
flux check

echo
echo "Apply flux-system kustomization ..."
kubectl apply -k ./k8s/cluster/flux-system -n flux-system

echo
echo "Reconcile flux-system ..."
flux reconcile kustomization -n flux-system flux-system --with-source --timeout 10m

./scripts/wait-for-sync.sh

./scripts/port-forward.sh

k6 run ./test/cluster-smoke-test.js

./scripts/next-steps.sh
