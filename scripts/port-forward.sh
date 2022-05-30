#!/bin/bash
# port-forward.sh - expose k8s cluster services with port forwarding

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

flux get all

echo
echo "Wait for infrastructure to be ready ..."
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/finalizers --for=condition=ready --timeout=10m
echo
echo "Wait for tools to be ready ..."
kubectl -n flux-system wait kustomization/tools --for=condition=ready --timeout=10m

# # Expose Kynervo Policy Reporter
# if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8082") ]]; then
#   kubectl -n policy-reporter port-forward service/policy-reporter-policy-reporter-ui 8082:8080 > /dev/null 2>&1 &
# fi

# Expose Linkerd-Viz dashboards
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8084") ]]; then
  kubectl -n linkerd-viz port-forward svc/web 8084:8084 > /dev/null 2>&1 &
fi

# Expose Grafana dashboards
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:3000") ]]; then
  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80 > /dev/null 2>&1 &
fi

# Expose Litmus ChaosCenter
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:9091") ]]; then
  kubectl -n litmus port-forward svc/chaos-litmus-frontend-service 9091:9091 > /dev/null 2>&1 &
fi

echo
echo "Cluster Dashboards:"
echo "-------------------"
echo
echo "View Flux dashboard in Grafana:"
echo
echo "  username: admin"
echo "  password: prom-operator"
echo
echo "Flux Cluster Stats: http://localhost:3000/d/flux-cluster/flux-cluster-stats"
echo "Flux Control Plane: http://localhost:3000/d/flux-control-plane"
echo
echo
echo "View Linkerd Service Mesh status:"
echo
echo "Linkerd dashboard:  http://localhost:8084"
echo "Grafana dashboard:  http://localhost:8084/grafana"
# echo
# echo
# echo "View Kynervo Policy Reporter:"
# echo
# echo "Policy Reporter:    http://localhost:8082"
echo
echo
echo "View Litmus ChaosCenter:"
echo
echo "Litmus:             http://localhost:9091/"
echo
