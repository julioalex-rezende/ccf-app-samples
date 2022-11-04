# CCF Environment Setup

## Azure Hosting Environment
- Azure Virtual Machine - not support TEE hardware - will work with virtual mode only
- Azure Confidential Computing (Virtual Machine) - Which Support SGX TEE (Trusted Execution Environment)

## Remote Access Azure VM using SSH
cd /mnt/c/ayman/repos/azure/ccf-vm
sudo ssh -i accvm-key-pair.pem azureuser@20.254.140.95

### Clone samples repo
mkdir repos && cd ~/repos

git clone https://github.com/Aymalla/ccf-app-samples.git

cd ccf-app-samples && mkdir run-app && cd run-app

cp ~/repos/ccf-app-samples/banking-app/constitutions/resolve.js .

cp ~/repos/ccf-app-samples/banking-app/deploy/config/*.json .

cp ~/repos/ccf-app-samples/banking-app/deploy/proposals/app_proposal.json .

cp -r ~/repos/ccf-app-samples/banking-app/deploy/scripts/ . && chmod u+x scripts/*.sh


## Install CCF on fresh VM
./scripts/setup_ccf_on_vm.sh

## Start a ccf test network  & deploy the sample application using docker image
## setupType: {"virtual": "virtual ccf network (not need for TEE hardware)" , "release":  "SGX ccf network (need a TEE hardware)"}
node_url="https://172.17.0.2:8080"

./scripts/setup_test_network.sh $node_url "virtual"
#./scripts/setup_test_network.sh $node_url "release"

## Run application testing
./scripts/run_app_test.sh $node_url
