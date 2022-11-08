# CCF Application Test Environment Setup

## Azure Hosting Environment
- Azure Confidential Computing (VM - Linux) 
    - SGX hardware is installed as TEE (Trusted Execution Environment) 
    - Both Release and Virtual modes will be supported
- Or Normal Azure Virtual Machine (Linux) 
    - No TEE hardware installed 
    - Only Virtual mode will be supported

## Remote Access your Azure VM using SSH

sudo ssh -i ./key.pem user@VMIP

## Install CCF runtime on fresh VM
./scripts/setup_ccf_on_vm.sh

### Clone samples repo
mkdir repos && cd ~/repos

git clone https://github.com/Aymalla/ccf-app-samples.git

cd  ccf-app-samples 
git checkout aym/dev-getstarted
cd ..

cd ccf-app-samples && mkdir run-app && cd run-app

cp ~/repos/ccf-app-samples/config/*.json .

cp ~/repos/ccf-app-samples/docker/* .

cp ~/repos/ccf-app-samples/banking-app/constitutions/*.js .

cp ~/repos/ccf-app-samples/banking-app/test/proposals/*.json .

cp -r ~/repos/ccf-app-samples/banking-app/test/scripts/*.sh .
cp /opt/ccf/bin/keygenerator.sh .
cp /opt/ccf/bin/scurl.sh .

chmod u+x *.sh

sed -i 's/127.0.0.1/172.17.0.2/g' cchost_config_enclave_js.json # replace container IP inside config

sed -i 's/127.0.0.1/172.17.0.2/g' cchost_config_virtual_js.json # replace container IP inside config


## Start a ccf test network  & deploy the sample application using docker image
## setupType: {"virtual": "virtual ccf network (not need for TEE hardware)" , "release":  "SGX ccf network (need a TEE hardware)"}
node_url="https://172.17.0.2:8080"

#./setup_test_network.sh $node_url "virtual"
./setup_test_network.sh $node_url "release"

## Run application testing
./run_app_test.sh $node_url
