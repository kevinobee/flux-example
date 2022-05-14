#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo
echo "Setup required CLI tools (uses Homebrew on Linux) ..."    # ref: https://brew.sh/
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE

brewTools=( \
  "kind" \
  "krew" \
  "kubescape" \
  "linkerd" \
  "octant"
)

if [ ! $(which brew) ]; then
  (
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  )
fi

for i in "${brewTools[@]}"
do
  if [[ ! $(brew list "${i}") ]]; then
    brew install "${i}"
  fi
done

if [[ ! $(which "flux") ]]; then
  brew install "fluxcd/tap/flux"
fi

echo
echo "Setup kubectl plugins ..."    # ref: https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/
if [ ! $(echo ${PATH} | grep ".krew/bin") ]; then
  export PATH="${PATH}:${HOME}/.krew/bin"
fi

kubectlPlugins=( \
  "starboard"
)

kubectl krew update

for i in "${kubectlPlugins[@]}"
do
  if [[ ! $(kubectl "${i}" version) ]]; then
    kubectl krew install ${i}
  fi
done

echo
echo "Setup Kubernetes cluster ..."
if [ ! $(kind get clusters --quiet) ]; then
  kind create cluster
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
echo "Wait for infrastructure to be ready ..."
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/finalizers --for=condition=ready --timeout=10m

# Expose Kynervo Policy Reporter
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8082") ]]; then
  kubectl -n policy-reporter port-forward service/policy-reporter-policy-reporter-ui 8082:8080 > /dev/null 2>&1 &
fi

# Expose Linkerd-Viz dashboards
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:8084") ]]; then
  kubectl -n linkerd-viz port-forward svc/web 8084:8084 > /dev/null 2>&1 &
fi

# Expose Grafana dashboards
if [[ ! $(netstat -tlp | grep kubectl | grep "localhost:3000") ]]; then
  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80 > /dev/null 2>&1 &
fi

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
echo "watch flux get all"
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
echo "View Flux dashboard in Grafana:"
echo
echo "Flux Cluster Stats: http://localhost:3000/d/flux-cluster/flux-cluster-stats"
echo "Flux Control Plane: http://localhost:3000/d/flux-control-plane"
echo
echo
echo "View the cluster configuration dashboard:"
echo
echo "octant"
echo
echo
echo "View Linkerd Service Mesh status:"
echo
echo "Linkerd dashboard:  http://localhost:8084"
echo "Grafana dashboard:  http://localhost:8084/grafana"
echo
echo
echo "View Kynervo Policy Reporter:"
echo
echo "Policy Reporter:    http://localhost:8082"
echo
echo
echo "View Litmus ChaosCenter:"
echo
echo "kubectl -n litmus port-forward svc/chaos-litmus-frontend-service 9091:9091 > /dev/null 2>&1 &"
echo
echo "Litmus:             http://localhost:9091/"
echo
echo
echo "Run Kubescape scan:"
echo
echo "kubescape scan --exclude-namespaces kube-system,kube-public,kube-node-lease,local-path-storage,litmus"
echo
