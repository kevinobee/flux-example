#!/bin/bash
# port-forward.sh - expose k8s cluster services with port forwarding

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo 'Expose Grafana on http://localhost:3000'
if [[ ! $(ps -ef | grep port-forward | grep grafana | grep 3000) ]]; then
  kubectl -n monitoring port-forward svc/monitoring-kube-prometheus-stack-grafana 3000:80 > /dev/null &
fi

echo 'Expose Policy Reporter on http://localhost:8082'
if [[ ! $(ps -ef | grep port-forward | grep policy-reporter | grep 8082) ]]; then
  kubectl -n policy-reporter port-forward service/policy-reporter-policy-reporter-ui 8082:8080 > /dev/null &
fi

echo 'Expose Litmus Chaos on http://localhost:9091'
if [[ ! $(ps -ef | grep port-forward | grep litmuschaos | grep 9091) ]]; then
  kubectl -n litmus port-forward svc/litmus-litmuschaos-frontend-service 9091:9091 > /dev/null &
fi

echo 'Expose Podinfo on http://localhost:9898'
if [[ ! $(ps -ef | grep port-forward | grep podinfo | grep 9898) ]]; then
  kubectl -n podinfo port-forward svc/podinfo 9898:9898 > /dev/null &
fi
