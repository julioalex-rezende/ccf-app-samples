#!/bin/bash
set -euo pipefail

node_url=$1
node_ip=$2

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
    
    local proposalFileName="network_open_proposal.json"
    cat <<JSON > $proposalFileName
{
  "actions": [
    {
      "name": "set_member",
      "args": {
        "cert": "${member1_cert}\n",
        "encryption_pub_key": "${member1_encryption_pub_key}\n"
      }
    },
    {
      "name": "set_user",
      "args": {
        "cert": "${user0_cert}\n"
      }
    },
    {
      "name": "set_user",
      "args": {
        "cert": "${user1_cert}\n"
      }
    },
    {
      "name": "transition_service_to_open",
      "args": {
        "next_service_identity": "${service_cert}\n"
      }
    }
  ]
}
JSON
}


# print new line
print_line()
{
    printf '\n%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
}

sudo mkdir -p /usr/lib/ccf

sudo cp /opt/ccf/lib/libjs_generic.virtual.so /usr/lib/ccf

cd ~/repos/ccf-app-samples/run-app

# create member0 cert
create_certificate "member0"

sed -i 's|/app/||g' cchost_config_virtual_js.json # replace container IP inside config

sudo rm -f -r ledger
/opt/ccf/bin/cchost --config cchost_config_virtual_js.json > /dev/null 2>&1 &

print_line
sleep 10


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

