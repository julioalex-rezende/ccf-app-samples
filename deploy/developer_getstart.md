# Get Started Application Development with CCF

## Quick start
What is CCF:The [Confidential Consortium Framework (CCF)](https://ccf.dev/) is an open-source framework for building a new category of secure, highly available,
and performant applications that focus on multi-party compute and data.

- Read the [CCF overview](https://ccf.microsoft.com/) and get familiar with [CCF's core concepts](https://microsoft.github.io/CCF/main/overview/what_is_ccf.html)
- [Build new CCF applications](https://microsoft.github.io/CCF/main/build_apps/index.html) in TypeScript/JavaScript or C++
- CCF application start up repos
    -  [Empty CCF application Template](https://github.com/microsoft/ccf-app-template)
    -  [Samples CCF application](https://github.com/microsoft/ccf-app-template)

## Supported Programing Languages
Applications can be written in
- TypeScript
- JavaScript
- C++

## Development environment
- Development container and VSCode [![Open in VSCode](https://img.shields.io/static/v1?label=Open+in&message=VSCode&logo=visualstudiocode&color=007ACC&logoColor=007ACC&labelColor=2C2C32)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/microsoft/ccf-app-template) 
- Linux VM ([Install ccf as prerequisites](https://microsoft.github.io/CCF/main/build_apps/install_bin.html))
- Github codespace: [![Github codespace](https://img.shields.io/static/v1?label=Open+in&message=GitHub+codespace&logo=github&color=2F363D&logoColor=white&labelColor=2C2C32)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=496290904&machine=basicLinux32gb&devcontainer_path=.devcontainer.json&location=WestEurope)

## Application Testing (JS/Typescript)

To test a ccf application you need to 
- Start and open a CCF Network with at least one (node - active member - user)
- Create Application [deployment proposal](https://microsoft.github.io/CCF/main/build_apps/js_app_bundle.html)
- Submit the app deployment proposal to the network and all members accept it through voting, This is a part of [Network Governance](https://microsoft.github.io/CCF/main/governance/proposals.html).
- Start to test you application endpoints

### Testing: Using Sandbox.sh

When you run the Sandbox.sh script, it is automatically starting a CCF network and deploy your application on it, and you app ready to receive calls

```bash
npm --prefix ./js install
npm --prefix ./js run build
/opt/ccf/bin/sandbox.sh --js-app-bundle ./js/dist/
```

### Testing: Using Virtual docker container 

When you build and run the docker file "ccf_app_js.virtual", it is only starting a CCF network with one node and one member
you need to make the following governance steps to deploy your application and open the network for users to access the endpoints.
all the governance steps is done using proposal submit and vote process (all these steps can be done in one proposal)
- Activate the member
- Add users
- Deploy the application
- Open the network for users
