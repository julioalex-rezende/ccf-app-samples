# CCF Application Test Environment Setup

## Azure Hosting Environment
- Azure Confidential Computing VM with [TEE hardware [Azure DC series] (Confidential Linux Image)](https://learn.microsoft.com/en-us/azure/confidential-computing/quick-create-portal)
    - SGX hardware is installed as TEE (Trusted Execution Environment) 
    - Both Release and Virtual modes will be supported
- Or Normal Azure Virtual Machine [(Confidential Linux Image)](https://learn.microsoft.com/en-us/azure/confidential-computing/create-confidential-vm-from-compute-gallery)
    - No TEE hardware installed 
    - Only Virtual mode will be supported

## Remote Access your Azure VM using SSH
```bash
sudo ssh -i ./key.pem user@VMIP
```
## Install CCF runtime on fresh VM
```bash
./scripts/setup_ccf_on_vm.sh
```

### Clone samples repo
```bash
# node_ip="10.2.0.4" #VM
# node_ip="172.17.0.2" #Container
node_url="https://${node_ip}:8080"

mkdir repos && cd ~/repos
git clone https://github.com/Aymalla/ccf-app-samples.git
cd  ccf-app-samples 
git checkout aym/dev-getstarted
cd ..
cd ccf-app-samples && mkdir run-app && cd run-app
cp ~/repos/ccf-app-samples/config/*.json .
cp ~/repos/ccf-app-samples/docker/* .

# copy default constitutions
cp /opt/ccf/bin/*.js .
# copy override constitutions
cp ~/repos/ccf-app-samples/banking-app/constitutions/*.js .

# copy proposals
cp ~/repos/ccf-app-samples/banking-app/test/proposals/*.json .

# copy scripts
cp -r ~/repos/ccf-app-samples/banking-app/test/scripts/*.sh .
cp /opt/ccf/bin/keygenerator.sh .
cp /opt/ccf/bin/scurl.sh .
chmod +x *.sh

# replace node ip in config files
sed -i "s|127.0.0.1|${node_ip}|g" cchost_config_enclave_js.json # replace container IP inside config
sed -i "s|127.0.0.1|${node_ip}|g" cchost_config_virtual_js.json # replace container IP inside config

# Start a CCF test network  & deploy the sample application using docker image
# setupType: {"virtual": "virtual ccf network (not need for TEE hardware)" , "release":  "SGX ccf network (need a TEE hardware)"}

#./setup_test_network.sh $node_url "virtual"
#./setup_test_network.sh $node_url "release"
./setup_test_network_using_VM.sh $node_url $node_ip

# Run application testing
./run_app_test.sh $node_url

```
