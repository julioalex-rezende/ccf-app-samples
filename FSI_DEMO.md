# FSI DEMO > CCF (Confidential Consortium Framework)

## Context

We are the Neutrino team, currently working on internal engagement with the CCF team to
- Upskilling on CCF concept and application 
- Improve developer experience by providing documentation feedback.
- Create a new application sample (data reconciliation).

## What is CCF?

The Confidential Consortium Framework (CCF) is an open-source framework for building a new category of secure, highly-available, and performant applications that focus on multi-party compute and data.

Leveraging the power of trusted execution environments (TEE, or "enclave"), decentralised systems concepts, and cryptography, CCF enables enterprise-ready multiparty systems.

CCF is based on web technologies; clients interact with CCF JavaScript applications over HTTPS.

![CCF Network](https://microsoft.github.io/CCF/main/_images/about-ccf.png)


## CCF Network Attributes

- **Nodes** [Run on TEE > secure] [multi-nodes > highly-available and performant]
- **Constitution** [How the network will be governed- JavaScript module that defines possible governance actions, and how members’ proposals are validated, resolved and applied to the service]
- **Operators** [Are in charge of operating a CCF network (e.g. adding or removing nodes)]
- **Members** [Constitute the consortium governing a CCF network (proposal submission and voting), such as banks]
- **Users** [Users directly interact with the application running in CCF (bank customers)]
- **Proposals** [Used to deploy any network change (application upgrade for new members and users)]
- **Ledger** [All changes to the Key-Value Store are encrypted and recorded to disc by each network node, resulting in a decentralised auditable ledger]
- **Application** (the business application)

## Applications


![Applications](https://learn.microsoft.com/en-us/azure/confidential-computing/media/use-cases-scenarios/use-cases.png)

[Secure multi-party systems](https://learn.microsoft.com/en-us/azure/confidential-computing/use-cases-scenarios) can be written in [TypeScript, JavaScript, C++, and more will be supported in the future]

## Samples

A sample application for a bank consortium: A bank system that can be run by multiple banks

https://github.com/microsoft/ccf-app-samples/tree/main/banking-app
