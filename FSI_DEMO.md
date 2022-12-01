# FSI DEMO > CCF (Confidential Consortium Framework)

## Context

We are the Neutrino team, currently working on internal engagement with the CCF team to
- CCF concept and application training
- Improve developer experience by providing documentation feedback.
- Create a new application sample (data reconciliation).

What is CCF?

The Confidential Consortium Framework (CCF) is an open-source framework for building a new category of secure, highly-available, and performant applications that focus on multi-party compute and data.

Leveraging the power of trusted execution environments (TEE, or "enclave"), decentralised systems concepts, and cryptography, CCF enables enterprise-ready multiparty systems.

CCF is based on web technologies; clients interact with CCF JavaScript applications over HTTPS.

![CCF Network](https://microsoft.github.io/CCF/main/_images/about-ccf.png)


## CCF Network Attributes

- Nodes [Run on TEE > secure] Nodes[multi-nodes > highly-available and performant]
- Constitution [How the network will be governed]
- Members [Who will run and govern the network (proposal submission and voting), such as banks]
- Users [Actual users of the network (bank customers)]]
- Proposals [Used to deploy any network change (application upgrade for new members and users)]
- Ledger [All changes to the Key-Value Store are encrypted and recorded to disc by each network node, resulting in a decentralised auditable ledger.]
- Application (the business application)

## Applications

Multiparty systems can be written in [TypeScript, JavaScript, C++, and more will be supported in the future]

## Samples

A sample application for a bank consortium: A bank system that can be run by multiple banks

https://github.com/microsoft/ccf-app-samples/tree/main/banking-app
