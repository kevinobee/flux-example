#!/bin/bash
# debug-failure.sh - dump cluster status to diagnose a failure in flux reconciliation loop

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

kubectl get ns
kubectl get crd
kubectl -n flux-system get all
kubectl -n flux-system logs deploy/source-controller
kubectl -n flux-system logs deploy/kustomize-controller
kubectl -n flux-system logs deploy/helm-controller

flux get all --all-namespaces
