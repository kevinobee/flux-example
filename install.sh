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
flux get all

echo
echo "Next steps:"
echo "-----------"
echo
echo "Watch status of all Flux resources:"
echo
echo "watch flux get all --all-namespaces"
echo
echo
echo "Force Flux reconciliation:"
echo
echo "flux reconcile kustomization flux-system --with-source"
echo
echo
echo "View Flux Kustomization tree:"
echo
echo "flux tree kustomization flux-system --compact"
echo
echo
echo "Setup port forwards to expose Cluster dashboards:"
echo
echo "./scripts/port-forward.sh"
echo
echo
echo "View the cluster configuration dashboard:"
echo
echo "octant"
echo
echo
echo "Run Sanitizers against cluster configuration:"
echo
echo "popeye"
echo
echo
echo "Run Kubescape scan:"
echo
echo "kubescape scan --exclude-namespaces kube-system,kube-public,kube-node-lease,local-path-storage,litmus"
echo
