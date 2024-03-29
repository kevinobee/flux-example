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
  "kustomize"
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
