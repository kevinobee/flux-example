#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications

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
  --path=./cluster \
  --personal

echo
flux tree kustomization flux-system --compact
echo
flux get all --all-namespaces

echo
echo "Next Step:"
echo "--------- "
echo
echo "Wait for Flux to sync cluster applications:"
echo
echo "./scripts/wait-for-sync.sh"
echo

