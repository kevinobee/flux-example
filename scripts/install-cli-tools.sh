#!/bin/bash
# install-cli-tools.sh - installs CLI tools using HomeBrew

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
  "k6" \
  "kind" \
  "krew" \
  "kubescape"
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

if [[ ! $(which "popeye") ]]; then
  brew install "derailed/popeye/popeye"
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

