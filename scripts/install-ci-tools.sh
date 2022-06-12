#!/bin/bash
# install-ci-tools.sh - installs CLI tools using HomeBrew for CI runners

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

export HOMEBREW_NO_INSTALL_CLEANUP=TRUE

brewTools=( \
  "kubescape"
)

if [ ! $(which brew) ]; then
  (
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  )
fi

for i in "${brewTools[@]}"
do
  if [[ ! $(which "${i}") ]]; then
    brew install "${i}"
  fi
done

if [[ ! $(which "flux") ]]; then
  brew install "fluxcd/tap/flux"
fi
