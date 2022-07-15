---
description: 'Choose how you want to use Tower.'
---

Tower is available in three different forms:

- **Tower Cloud**: The hosted version of Tower is available free of charge at [tower.nf](https://tower.nf). This version is for individuals and organizations that want to get setup fast. It is the recommended way for users to become familiar with Tower. The service is hosted by Seqera Labs.

- **Tower Community**: The Community edition of Tower is open-source and can be deployed by anyone on their own infrastructure. The community edition has basic features for the monitoring of pipelines by an individual user.

- **Tower Enterprise**: The Enterprise edition of Tower contains the latest features and can be deployed in an organization's own cloud or on-premises infrastructure. This option includes dedicated support from Seqera Labs and is recommended for production environments.


## Tower Cloud

To try Tower Cloud, visit [tower.nf](https://tower.nf/login) and log in with your GitHub or Google credentials. The [Launching Pipelines](../launch/launch.md) page provides step-by-step instructions to launch your first pipeline. Tower Cloud has a limit of five concurrent workflow runs per user.

![](_images/starting_tower_nf.png)


## Tower Community

For instructions on how to install the Community edition of Tower, visit the [GitHub repository](https://github.com/seqeralabs/nf-tower).

![](_images/starting_tower_opensource.png)

!!! warning
    Tower Community does not have all of the features included in Tower Cloud and Tower Enterprise, such as **Tower Launch**, **Organizations**, and **Workspaces**.


## Tower Enterprise

Tower Enterprise is installed within an organization's own cloud or on-premises infrastructure. It includes:

- Monitoring, logging, & observability
- Pipeline execution launchpad
- Cloud resource provisioning
- Pipeline actions and event-based execution
- LDAP & OpenID Authentication
- Enterprise role-based access control
- Fully featured API
- Support for Nextflow & Tower

To install the Tower in your organization, contact [Seqera Labs](https://cloud.tower.nf/demo/) for a demo and to discuss your requirements.

![](_images/starting_tower_enterprise.png)
