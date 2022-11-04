#!/bin/bash
set -euo pipefail

node_url=$1

print_line()
{
    printf '\n%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
}

echo "Run the sample application tests"

echo "Define vars"
user0_id=$(openssl x509 -in "user0_cert.pem" -noout -fingerprint -sha256 | cut -d "=" -f 2 | sed 's/://g' | awk '{print tolower($0)}')
user1_id=$(openssl x509 -in "user1_cert.pem" -noout -fingerprint -sha256 | cut -d "=" -f 2 | sed 's/://g' | awk '{print tolower($0)}')
account_type0='current_account'
account_type1='savings_account'

echo "create accounts"
curl $node_url/app/account/$user0_id/$account_type0 -X PUT --cacert service_cert.pem --cert member0_cert.pem --key member0_privk.pem
curl $node_url/app/account/$user1_id/$account_type1 -X PUT --cacert service_cert.pem --cert member0_cert.pem --key member0_privk.pem

echo "deposit and display balance for account0"
curl $node_url/app/deposit/$user0_id/$account_type0 -X POST --cacert service_cert.pem --cert member0_cert.pem --key member0_privk.pem -H "Content-Type: application/json" --data-binary '{ "value": 100 }'
curl $node_url/app/balance/$account_type0 -X GET --cacert service_cert.pem --cert user0_cert.pem --key user0_privk.pem
print_line

echo "deposit and display balance for account1"
curl $node_url/app/deposit/$user1_id/$account_type1 -X POST --cacert service_cert.pem --cert member0_cert.pem --key member0_privk.pem -H "Content-Type: application/json" --data-binary '{ "value": 2000 }'
curl $node_url/app/balance/$account_type1 -X GET --cacert service_cert.pem --cert user1_cert.pem --key user1_privk.pem
print_line

echo "Transfer 40 from user0 to user1"
transfer_transaction_id=$(curl $node_url/app/transfer/$account_type0 -X POST -i --cacert service_cert.pem --cert user0_cert.pem --key user0_privk.pem -H "Content-Type: application/json" --data-binary "{ \"value\": 40, \"user_id_to\": \"$user1_id\", \"account_name_to\": \"$account_type1\" }" | grep -i x-ms-ccf-transaction-id | awk '{print $2}' | sed -e 's/\r//g')
echo "transaction ID of the transfer: $transfer_transaction_id"
echo "Display reciept"
curl $node_url/app/receipt?transaction_id=$transfer_transaction_id --cacert service_cert.pem --key user0_privk.pem --cert user0_cert.pem
print_line

echo "Display balance"
curl $node_url/app/balance/$account_type0 -X GET --cacert service_cert.pem --cert user0_cert.pem --key user0_privk.pem
curl $node_url/app/balance/$account_type1 -X GET --cacert service_cert.pem --cert user1_cert.pem --key user1_privk.pem
print_line

echo "Transfer 1000 from user1 to user0"
transfer_transaction_id=$(curl $node_url/app/transfer/$account_type1 -X POST -i --cacert service_cert.pem --cert user1_cert.pem --key user1_privk.pem -H "Content-Type: application/json" --data-binary "{ \"value\": 1000, \"user_id_to\": \"$user0_id\", \"account_name_to\": \"$account_type0\" }" | grep -i x-ms-ccf-transaction-id | awk '{print $2}' | sed -e 's/\r//g')
echo "transaction ID of the transfer: $transfer_transaction_id"
curl $node_url/app/receipt?transaction_id=$transfer_transaction_id --cacert service_cert.pem --key user1_privk.pem --cert user1_cert.pem
print_line

echo "Display balance"
curl $node_url/app/balance/$account_type0 -X GET --cacert service_cert.pem --cert user0_cert.pem --key user0_privk.pem
curl $node_url/app/balance/$account_type1 -X GET --cacert service_cert.pem --cert user1_cert.pem --key user1_privk.pem
print_line
