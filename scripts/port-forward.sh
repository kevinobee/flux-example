#!/bin/bash
# port-forward.sh - expose k8s cluster services with port forwarding

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

# Expose monitoring Grafana on port 3000
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:3000") ]]; then
  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80 > /dev/null 2>&1 &
fi

# # Expose Kynervo Policy Reporter
# if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8082") ]]; then
#   kubectl -n policy-reporter port-forward service/policy-reporter-policy-reporter-ui 8082:8080 > /dev/null 2>&1 &
# fi

# Expose Emojivoto on port 8080
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8080") ]]; then
  kubectl -n emojivoto port-forward svc/web-svc 8080:80 > /dev/null 2>&1 &
fi

# Expose Litmus ChaosCenter on port 9091
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:9091") ]]; then
  kubectl -n litmus port-forward svc/litmus-litmuschaos-frontend-service 9091:9091 > /dev/null 2>&1 &
fi
