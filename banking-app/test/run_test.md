# CCF Test Environment Setup

## Azure Hosting Environment
- Azure Confidential Computing (VM - Linux) - Support SGX TEE (Trusted Execution Environment)
- Azure Virtual Machine - no support for TEE hardware - will work with virtual mode only

## Remote Access Azure VM using SSH
cd /mnt/c/ayman/repos/azure/ccf-vm
sudo ssh -i accvm-key-pair.pem azureuser@20.254.140.95

### Clone samples repo
mkdir repos && cd ~/repos

git clone https://github.com/Aymalla/ccf-app-samples.git

cd  ccf-app-samples 
git checkout aym/dev-getstarted
cd ..

cd ccf-app-samples && mkdir run-app && cd run-app

cp ~/repos/ccf-app-samples/config/*.json .

cp ~/repos/ccf-app-samples/docker/* .

cp ~/repos/ccf-app-samples/banking-app/test/proposals/*.json .

cp -r ~/repos/ccf-app-samples/banking-app/test/scripts/ . && chmod u+x scripts/*.sh

sed -i 's/127.0.0.1/172.17.0.2/g' cchost_config_enclave_js.json # replace container IP
sed -i 's/127.0.0.1/172.17.0.2/g' cchost_config_virtual_js.json # replace container IP

## Install CCF on fresh VM
./scripts/setup_ccf_on_vm.sh

## Start a ccf test network  & deploy the sample application using docker image
## setupType: {"virtual": "virtual ccf network (not need for TEE hardware)" , "release":  "SGX ccf network (need a TEE hardware)"}
node_url="https://172.17.0.2:8080"

#./scripts/setup_test_network.sh $node_url "virtual"
./scripts/setup_test_network.sh $node_url "release"

## Run application testing
./scripts/run_app_test.sh $node_url
