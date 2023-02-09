---
description: 'Using Wave'
---

From version 22.4.0, Tower supports Seqera's Wave containers service for on-premise installations. 
See Wave's features [here](https://wave.seqera.io), and Wave integration with Nextflow [here](https://www.nextflow.io/docs/latest/wave.html).


## Pairing Tower with Wave

Pairing Tower with Wave requires the following:
- `https://wave.seqera.io` should be accessible to the Tower network (i.e. the domain should be whitelisted in protected Tower installations)
- The Tower installation should allow ingress traffic from the Wave service
- The `TOWER_ENABLE_WAVE` environment variable must be set to `true`, or the `enable_wave` parameter set to `true` in your tower.yml configuration

When these conditions are met, the Wave feature is available on the Tower compute environment creation page (available for AWS compute environments only)

Once Wave is enabled, a secure channel is established between Tower and the Wave service to exchange encrypted data securely.

Wave can also be enabled in the Nextflow pipeline config file. See [here](https://www.nextflow.io/docs/latest/wave.html) for more information.