#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

# Homebrew on Linux - ref: https://brew.sh/
if [ ! $(which brew) ]; then
  (
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  )
fi

brewTools=( \
  "kind" \
  "octant"
)

for i in "${brewTools[@]}"
do
  if [[ ! $(which "${i}") ]]; then
    echo "Installing ${i} CLI ... "
    brew install ${i} -q
  fi
done

if [[ ! $(which "flux") ]]; then
  brew install "fluxcd/tap/flux" -q
fi

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
echo "To watch Flux kustomizations run:"
echo
echo "kubectl get kustomizations.kustomize.toolkit.fluxcd.io -A -w"
echo
echo
echo "To view the cluster configuration run:"
echo
echo "octant"
echo
