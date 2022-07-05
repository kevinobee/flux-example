#!/bin/bash
# port-forward.sh - expose k8s cluster services with port forwarding

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo 'Expose Grafana on port 3000'
if [[ ! $(netstat -tlp 2> /dev/null | grep kubectl | grep "localhost:3000") ]]; then
  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80 > /dev/null &
fi

echo 'Expose Emojivoto on port 8080'
if [[ ! $(netstat -tlp 2> /dev/null | grep kubectl | grep "localhost:8080") ]]; then
  kubectl -n emojivoto port-forward svc/web-svc 8080:80 > /dev/null > /dev/null &
fi

echo 'Expose Policy Reporter on port 8082'
if [[ ! $(netstat -tlp 2> /dev/null | grep kubectl | grep "localhost:8082") ]]; then
  kubectl -n policy-reporter port-forward service/policy-reporter-policy-reporter-ui 8082:8080 > /dev/null &
fi

echo 'Expose Litmus Chaos on port 9091'
if [[ ! $(netstat -tlp 2> /dev/null | grep kubectl | grep "localhost:9091") ]]; then
  kubectl -n litmus port-forward svc/litmus-litmuschaos-frontend-service 9091:9091 > /dev/null &
fi

echo 'Expose Prometheus on port 9090'
if [[ ! $(netstat -tlp 2> /dev/null | grep kubectl | grep "localhost:9090") ]]; then
  kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090 > /dev/null &
fi
