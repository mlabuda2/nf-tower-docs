---
description: 'Using Wave'
---

From version 22.4, Tower supports Seqera Labs' Wave containers service for on-premise installations. 

Learn more about Wave's features [here](https://wave.seqera.io), and about Wave integration with Nextflow [here](https://www.nextflow.io/docs/latest/wave.html).


## Pairing Tower with Wave

Pairing Tower with Wave requires the following:

- `https://wave.seqera.io` should be accessible to the Tower network (i.e. the domain should be whitelisted in protected Tower installations)

- The Tower installation should allow ingress traffic from the Wave service

- The `TOWER_ENABLE_WAVE` environment variable must be set to `true`, or the `enable_wave` parameter set to `true` in your tower.yml configuration

When these conditions are met, the Wave feature is available on the Tower compute environment creation page (currently only available for AWS compute environments).

Once Wave is enabled, it will be possible to use private container repositories and the Fusion file system in your Nextflow pipelines.

Wave can also be enabled in the Nextflow pipeline config file. See [here](https://www.nextflow.io/docs/latest/wave.html) for more information.