#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo
echo "Install CLI tools using Homebrew on Linux ..."    # ref: https://brew.sh/

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
  if [[ ! $(which "${i}") ]]; then
    brew install ${i}
  fi
done

if [[ ! $(which "flux") ]]; then
  brew install "fluxcd/tap/flux"
fi

echo
echo "Install kubectl plugins ..."    # ref: https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/

kubectlPlugins=( \
  "starboard"
)

kubectl krew update

for i in "${kubectlPlugins[@]}"
do
  if [[ ! $(which "${i}") ]]; then
    kubectl krew install ${i}
  fi
done

echo
echo "Setup Kubernestes cluster ..."
if [ ! $(kind get clusters --quiet) ]; then
  kind create cluster
  kubectl wait node --all --for condition=ready
fi
kubectl cluster-info

echo
echo "Install Flux ..."
flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=flux-example \
  --branch=main \
  --path=./clusters/dev-cluster \
  --personal

echo
kubectl get gitrepository.source.toolkit.fluxcd.io -A
echo
kubectl get kustomizations.kustomize.toolkit.fluxcd.io -A

echo
echo
echo "Next steps:"
echo "-----------"
echo
echo "Watch Flux kustomizations run:"
echo
echo "kubectl get kustomizations.kustomize.toolkit.fluxcd.io -A -w"
echo
echo
echo "View the cluster configuration dashboard:"
echo
echo "octant"
echo
