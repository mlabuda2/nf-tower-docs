---
description: 'Using Wave'
---

Since version 22.4.x Tower supports Seqera's container augmentation service known as Wave also for on-premises installations. 
You can read more about its features [here](https://wave.seqera.io) and its integration with Nextflow [here](https://www.nextflow.io/docs/latest/wave.html)


## Pairing Tower with Wave

In order to activate the paring mechanism with Wave there are some prerequisites to be fullfilled:
- https://wave.seqera.io domain should be reachable by Tower network meaning that the domain should be whitelisted in case Tower installation is protected
- The tower installation should be available for inbound traffic coming from wave service
- The environment variable `TOWER_ENABLE_WAVE` should be set to the value `true`

Once the requisites above are fullfilled the wave functionality will be available for activation directly in Tower UI (feature available only for AWS)

Once wave is enabled a secure channel will be established between Tower installation and Wave service to securely exchange encrypted data.

Wave features could also be used by activating wave in the nextflow pipeline config, please read more [here](https://www.nextflow.io/docs/latest/wave.html)