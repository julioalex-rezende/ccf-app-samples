#!/bin/bash
set -euo pipefail

node_url=$1
setupType=$2

# create certificate files
create_certificate(){
    local certName="$1"
    local certFile="${1}_cert.pem"
    local setUserFile="set_${1}.json"
    ./keygenerator.sh --name $certName --gen-enc-key
}


# Prepare a test network by adding a member 
# and two users to the network, and then open it
create_test_network_proposal(){
    
    create_certificate "user0"
    create_certificate "user1"
    create_certificate "member1"

    local user0_cert=$(< user0_cert.pem sed '$!G' | paste -sd '\\n' -)
    local user1_cert=$(< user1_cert.pem sed '$!G' | paste -sd '\\n' -)
    local member1_cert=$(< member1_cert.pem sed '$!G' | paste -sd '\\n' -)
    local member1_encryption_pub_key=$(< member1_enc_pubk.pem sed '$!G' | paste -sd '\\n' -)
    local service_cert=$(< service_cert.pem sed '$!G' | paste -sd '\\n' -)
    
    # inject certs to network_open_proposal
    local proposalFileName="network_open_proposal.json"
    sed -i 's/member1_cert/${member1_cert}/g' $proposalFileName
    sed -i 's/member1_encryption_pub_key/${member1_encryption_pub_key}/g' $proposalFileName
    sed -i 's/user0_cert/${user0_cert}/g' $proposalFileName
    sed -i 's/user1_cert/${user1_cert}/g' $proposalFileName
    sed -i 's/service_cert/${service_cert}/g' $proposalFileName
}


# print new line
print_line()
{
    printf '\n%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
}


if [ $setupType = "release" ]
then
    echo "Start a test release sgx network with one node container"
    docker build -t ccf-app-samples:js-enclave -f ccf_app_js.enclave .
    docker run -d --device /dev/sgx_enclave:/dev/sgx_enclave --device /dev/sgx_provision:/dev/sgx_provision -v /dev/sgx:/dev/sgx ccf-app-samples:js-enclave
else
    echo "Start a test virtual network with one node container"
    docker build -t ccf-app-samples:js-virtual -f ccf_app_js.virtual .
    docker run -d ccf-app-samples:js-virtual
fi

print_line
sleep 10

echo "copy the generated service certs from the container"
containerId=$(docker ps -q)
cd ~/repos/ccf-app-samples/run-app
docker cp "$containerId:/app/service_cert.pem" .    
docker cp "$containerId:/app/member0_cert.pem" .
docker cp "$containerId:/app/member0_privk.pem" .

echo "create a network proposal"
create_test_network_proposal
print_line

echo "Activate Member 0"
curl "${node_url}/gov/ack/update_state_digest" -X POST --cacert service_cert.pem --key member0_privk.pem --cert member0_cert.pem --silent | jq > request.json
cat request.json
./scurl.sh "${node_url}/gov/ack"  --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --header "Content-Type: application/json" --data-binary @request.json
print_line

echo "Submit Application proposal and accept"
proposal0_out=$(./scurl.sh "${node_url}/gov/proposals" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @app_proposal.json -H "content-type: application/json")
proposal0_id=$( jq -r  '.proposal_id' <<< "${proposal0_out}" )
echo $proposal0_id
./scurl.sh "${node_url}/gov/proposals/$proposal0_id/ballots" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @vote_accept.json -H "content-type: application/json" | jq
print_line

echo "Submit Network open proposal and accept"
proposal0_out=$(./scurl.sh "${node_url}/gov/proposals" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @network_open_proposal.json -H "content-type: application/json")
proposal0_id=$( jq -r  '.proposal_id' <<< "${proposal0_out}" )
echo $proposal0_id
./scurl.sh "${node_url}/gov/proposals/$proposal0_id/ballots" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @vote_accept.json -H "content-type: application/json" | jq
print_line

echo "Test Network"
curl "${node_url}/node/network" --cacert service_cert.pem
print_line
curl "${node_url}/node/network/nodes" --cacert service_cert.pem
print_line
curl "${node_url}/node/version" --cacert service_cert.pem
print_line