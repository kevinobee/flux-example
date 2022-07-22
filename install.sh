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
  --path=./k8s/cluster \
  --personal

sleep 5s

./scripts/wait-for-sync.sh

./scripts/port-forward.sh

k6 run ./test/cluster-smoke-test.js

echo
echo "Next Steps:"
echo
echo
echo "Applications:"
echo "------------ "
echo
echo "Emojivoto:          http://localhost:8080/"
echo
echo
echo "Monitoring and Tools:"
echo "-------------------- "
echo
echo "Grafana:            http://localhost:3000   (initial credentials: admin/admin)"
echo
echo "Policy Reporter:    http://localhost:8082"
echo
echo "Litmus ChaosCenter: http://localhost:9091/"
echo
echo
echo "Cluster Dashboard:"
echo "----------------- "
echo
echo "brew install octant"
echo "octant"
echo
echo
echo "Service Mesh Dashboard:"
echo "---------------------- "
echo
echo "brew install linkerd"
echo "linkerd viz install | kubectl apply -f -"
echo "linkerd viz dashboard"
echo
echo
echo "Report Cluster Resource Issues:"
echo "------------------------------ "
echo
echo "popeye"
echo
echo
echo "Run Kubescape Scan:"
echo "------------------ "
echo
echo "kubescape scan --exclude-namespaces kube-system,kube-public,kube-node-lease,local-path-storage,litmus"
echo
