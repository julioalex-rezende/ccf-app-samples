# FSI DEMO > CCF (Confidential Consortium Framework)

## Context

We are the Neutrino team, currently working on internal engagement with CCF team to 
- Upskill on CCF concepts and applications
- Enrich developer experience by documentation feedback
- Create new application sample (Data- Reconciliation)

## What is CCF?

The Confidential Consortium Framework (CCF) is an open-source framework for building a new category of secure, highly-available, and performant applications that focus on multi-party compute and data.

Leveraging the power of trusted execution environments (TEE, or enclave), decentralised systems concepts, and cryptography, CCF enables enterprise-ready multiparty systems.

CCF is based on web technologies: clients interact with CCF JavaScript applications over HTTPS.

![CCF Network](https://microsoft.github.io/CCF/main/_images/about-ccf.png)


## CCF Network Attributes

- Nodes [Run on TEE > secure] -[multi-nodes >  highly-available and performant]
- Constitution [How the network will be governed]
- Members [Who will run and govern the network (Proposal Submitting - Proposal voting) like(Banks) ]
- Users [Actual users of the network (Bank Customers) ]
- Proposals [Used for deploying any change to the network (application upgrade - new members and users)]
- Ledger [All changes to the Key-Value Store are encrypted and recorded by each node of the network to disk to a decentralised auditable ledger.]
- Application (The business application)

## Applications

Multiparty systems
Applications can be written in [TypeScript - JavaScript - C++ - More upcoming]

## Samples

A sample application of a bank consortium: A bank system that can be run by multiple banks

https://github.com/microsoft/ccf-app-samples/tree/main/banking-app
