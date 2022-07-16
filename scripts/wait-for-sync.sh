#!/bin/bash
# wait-for-sync.sh - wait for k8s cluster services sync to complete

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo
echo "Wait for infrastructure to be ready ..."
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/finalizers --for=condition=ready --timeout=10m

echo
echo "Wait for applications to be ready ..."
kubectl -n flux-system wait kustomization/apps --for=condition=ready --timeout=5m
kubectl -n emojivoto wait kustomization/emojivoto --for=condition=ready --timeout=5m

echo
echo "Wait for tools to be ready ..."
kubectl -n flux-system wait kustomization/tools --for=condition=ready --timeout=10m
kubectl -n flux-system wait helmrelease/litmuschaos --for=condition=ready --timeout=10m

echo
flux get all --all-namespaces
