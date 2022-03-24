---
title: Frequently asked questions
headline: 'Frequently asked questions'
description: 'Frequently asked questions'
---


## Frequently asked questions

### Is my data safe?

**Description**

Yes, your data stays strictly within your infrastructure itself. When you launch a workflow through Tower, you need to connect **your** infrastructure (HPC/VMs/K8s) by creating the appropriate credentials and compute environment in a workspace.

Tower then uses this configuration to trigger a Nextflow workflow within your infrastructure similar to what is done via the Nextflow CLI, therefore Tower does not manipulate any data itself and no data is transferred to the infrastructure where Tower is running.





