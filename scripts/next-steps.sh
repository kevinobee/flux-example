#!/bin/bash
# next-steps.sh - display options for interacting with the running cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo
echo "Next Steps:"
echo
echo
echo "Applications:"
echo "------------ "
echo
echo "Podinfo:            http://localhost:9898/"
echo
echo
echo "Monitoring and Tools:"
echo "-------------------- "
echo
echo "Grafana:            http://localhost:3000   (initial credentials: admin/prom-operator)"
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
echo "linkerd viz install"
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
