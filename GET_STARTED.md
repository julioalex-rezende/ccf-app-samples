# Get Started: Application Development with CCF

## Quick start
What is CCF:The [Confidential Consortium Framework (CCF)](https://ccf.dev/) is an open-source framework for building a new category of secure, highly available,
and performant applications that focus on multi-party compute and data.

- Read the [CCF overview](https://ccf.microsoft.com/) and get familiar with [CCF's core concepts](https://microsoft.github.io/CCF/main/overview/what_is_ccf.html)
- [Build new CCF applications](https://microsoft.github.io/CCF/main/build_apps/index.html) in TypeScript/JavaScript or C++
- CCF [Modules API reference](https://microsoft.github.io/CCF/main/js/ccf-app/modules.html)
- CCF application get started repos
    -  [CCF application template](https://github.com/microsoft/ccf-app-template)
    -  [CCF application samples](https://github.com/microsoft/ccf-app-template)

## Supported Programing Languages
Applications can be written in
- TypeScript
- JavaScript
- C++
- More languages support upcoming on 2023

## Development environment
- Development container and VSCode [![Open in VSCode](https://img.shields.io/static/v1?label=Open+in&message=VSCode&logo=visualstudiocode&color=007ACC&logoColor=007ACC&labelColor=2C2C32)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/microsoft/ccf-app-template) 
- Github codespace: [![Github codespace](https://img.shields.io/static/v1?label=Open+in&message=GitHub+codespace&logo=github&color=2F363D&logoColor=white&labelColor=2C2C32)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=496290904&machine=basicLinux32gb&devcontainer_path=.devcontainer.json&location=WestEurope)
- Linux Machine ([Install ccf as prerequisites](https://microsoft.github.io/CCF/main/build_apps/install_bin.html))

## Application Testing (JS/Typescript)
To test a ccf application you need go through the following steps:
- Start a CCF Network with at least one node
- Initialize the CCF network with at least one (active member - user), this is done through [Network Governance Proposals](https://microsoft.github.io/CCF/main/governance/proposals.html).
- Create an application [deployment proposal](https://microsoft.github.io/CCF/main/build_apps/js_app_bundle.html)
- Submit the app deployment proposal to the network and all members accept it through voting, This is a part of [Network Governance](https://microsoft.github.io/CCF/main/governance/proposals.html).
- Open the CCF network for users
- Start to test your application endpoints

There are several options to test your application
- Sandbox.sh > build an initialized virtual ccf network
- Docker container > build both ccf network types [virtual - release (TEE hardware)]
- Linux Machine > Support both ccf network types [virtual - release]

### Testing: Using Sandbox.sh

By Runing sandbox.sh script, it is automatically starting a CCF network and deploy your application on it, the app is up and ready to receive calls,
all the governance work is done for you.

```bash
npm --prefix ./js install
npm --prefix ./js run build
/opt/ccf/bin/sandbox.sh --js-app-bundle ./js/dist/
```

### Testing: Using docker containers

Build and run one of these docker files ["ccf_app_js.virtual" or "ccf_app_js.enclave"] to start a CCF network with one node and one member
after that you need to execute governance steps to deploy the application and open the network for users to begin access the app endpoints.
all the governance steps is done manually using [proposal submit and vote process](https://microsoft.github.io/CCF/main/governance/proposals.html).

#### Build and run docker container to start a CCF network

Start a CCF network that support TEE hardware via docker container based on config file "./config/cchost_config_enclave_js.json"

```bash
 docker build -t ccf-app-samples:js-enclave -f docker/ccf_app_js.enclave .
 docker run -d --device /dev/sgx_enclave:/dev/sgx_enclave --device /dev/sgx_provision:/dev/sgx_provision -v /dev/sgx:/dev/sgx ccf-app-samples:js-enclave
```

Or virtual mode  based on virtual config file: "./config/cchost_config_virtual_js.json":
```bash
 docker build -t ccf-app-samples:js-virtual -f docker/ccf_app_js.virtual .
 docker run -d ccf-app-samples:js-virtual
```

#### CCF Node Configuration file
The configuration for each CCF node must be contained in a single JSON configuration file like [cchost_config_enclave_js.json - cchost_config_virtual_js.json], [ CCF node config file documentation](https://microsoft.github.io/CCF/main/operations/configuration.html)


#### CCF network initialization

After the container run, a network is started with one (node - member), you need to execute the following governance steps to initialize the network
- Activate the network members (to begin network governance)
- Add users (using proposal)
- Deploy the application (using proposal)
- Open the network for users (using proposal)

### Testing: Using Linux Machine
To Start a test CCF network on a VM, it requires [CCF to be intalled](https://microsoft.github.io/CCF/main/build_apps/install_bin.html)

Start the CCF network using the cchost in release mode
```bash
 /opt/ccf/bin/cchost --config ./config/cchost_config_enclave_js.json
```
Or virtual mode
```bash
/opt/ccf/bin/cchost --config ./config/cchost_config_virtual_js.json
```

#### CCF Node Configuration file
The configuration for each CCF node must be contained in a single JSON configuration file like [cchost_config_enclave_js.json - cchost_config_virtual_js.json], [ CCF node config file documentation](https://microsoft.github.io/CCF/main/operations/configuration.html)

#### CCF network initialization
Network is started with one (node - member), you need to execute the following governance steps to initialize the network
- Activate the network members (to begin network governance)
- Add users (using proposal)
- Deploy the application (using proposal)
- Open the network for users (using proposal)

# Network Governance
Consortium of trusted Members governs the CCF network. members can submit proposals to CCF and these proposals are accepted based on the rules defined in the [Constitution](https://microsoft.github.io/CCF/main/governance/constitution.html).
Governance changes are submitted to a [network as Proposals](https://microsoft.github.io/CCF/main/governance/proposals.html), and put to a vote from members.

Submit a proposal 
```bash
proposal0_out=$(./scurl.sh "https://ccf_node_url/gov/proposals" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @proposal.json -H "content-type: application/json")
proposal0_id=$( jq -r  '.proposal_id' <<< "${proposal0_out}" )
```

Members vote to accept or reject the proposal
```bash
./scurl.sh "https://ccf_node_url/gov/proposals/$proposal0_id/ballots" --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --data-binary @vote_accept.json -H "content-type: application/json" | jq
./scurl.sh "https://ccf_node_url/gov/proposals/$proposal0_id/ballots" --cacert service_cert.pem --signing-key member1_privk.pem --signing-cert member1_cert.pem --data-binary @vote_accept.json -H "content-type: application/json" | jq
```
 
## Network Governance: Activating network members 

By default the CCF network needs at least one member to be started, after the network is started this member must be activated.
[Adding or activating members](https://microsoft.github.io/CCF/main/governance/adding_member.html)

### Activate member
```bash
curl "https://ccf_node_url/gov/ack/update_state_digest" -X POST --cacert service_cert.pem --key member0_privk.pem --cert member0_cert.pem --silent | jq > request.json
cat request.json
./scurl.sh "https://ccf_node_url/gov/ack"  --cacert service_cert.pem --signing-key member0_privk.pem --signing-cert member0_cert.pem --header "Content-Type: application/json" --data-binary @request.json
```

### New member proposal
```json
{
  "actions": [
    {
        "name": "set_member",
        "args": {
            "cert": "member_cert",
            "encryption_pub_key": "member_encryption_pub_key"
        }
    }
  ]
}
```

## Network Governance: Adding users 
Users are directly interact with the application running in CCF. Their public identity should be voted in by members before they are allowed to issue requests.

Once a CCF network is successfully started and an acceptable number of nodes have joined, members should vote to open the network to Users. First, the identities of trusted users should be generated,see [Generating Member Keys and Certificates](https://microsoft.github.io/CCF/main/governance/adding_member.html#generating-member-keys-and-certificates)

### New user proposal
```json
{
  "actions": [
    {
        "name": "set_user",
        "args": {
            "cert": "user_cert"
        }
    }
  ]
}
```


## Deploy application using proposal
The native format for JavaScript applications in CCF is a [JavaScript application bundle](https://microsoft.github.io/CCF/main/build_apps/js_app_bundle.html), or short app bundle. A bundle can be wrapped directly into a governance proposal for deployment.

### Application deployment proposal

```json
{
  "actions": [
    {
      "name": "set_js_app",
      "args": {
        "bundle": {
          "metadata": { "endpoints": {} },
          "modules": []
        }
      }
    }
  ]
}
```

## Network Governance: Open network for users
Once users are added to the opening network, members should create a proposal to open the network,
Other members are then able to vote for the proposal using the returned proposal id.

Once the proposal has received enough votes under the rules of the Constitution (ie. ballots which evaluate to true), the network is opened to users. It is only then that users are able to execute transactions on the deployed application.

### Open network proposal
```json
{
  "actions": [
    {
        "name": "transition_service_to_open",
        "args": {
            "next_service_identity": "service_cert"
        }
    }
  ]
}
```
