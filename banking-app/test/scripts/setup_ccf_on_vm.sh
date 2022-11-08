#!/bin/bash
set -euo pipefail

echo "Install CCF" 

echo "Clone CCF Repo to be used in the Prerequisites Installation"
cd ~/repos
git clone https://github.com/microsoft/CCF.git

echo "Install CCF Prerequisites"
cd ~/repos/CCF/getting_started/setup_vm
./run.sh app-run.yml # Install Prerequisites

echo "Install CCF"
export CCF_VERSION=$(curl -ILs -o /dev/null -w %{url_effective} https://github.com/microsoft/CCF/releases/latest | sed 's/^.*ccf-//')
wget https://github.com/microsoft/CCF/releases/download/ccf-${CCF_VERSION}/ccf_${CCF_VERSION}_amd64.deb
sudo apt install ./ccf_${CCF_VERSION}_amd64.deb

echo "Verify the installation"
/opt/ccf/bin/cchost --version

echo "Install jq"
sudo apt  install jq

echo "Install Docker"
sudo apt  install docker.io

### Run docker without sudo
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker start
 