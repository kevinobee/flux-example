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
echo "Wait for reconcile to complete ..."
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=1m
kubectl -n flux-system wait kustomization/apps --for=condition=ready --timeout=1m
kubectl -n flux-system wait kustomization/tools --for=condition=ready --timeout=1m
echo
flux tree kustomization flux-system

echo
echo "Next steps:"
echo "-----------"
echo
echo "View the cluster configuration dashboard:"
echo
echo "octant"
echo
echo
echo "Force Flux reconciliation:"
echo
echo "flux reconcile kustomization flux-system --with-source"
echo "flux get all"
echo
echo
echo "View Flux Kustomization tree:"
echo
echo "flux tree kustomization flux-system"
echo