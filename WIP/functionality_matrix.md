---
title: Functionality Matrix
headline: 'Functionality Matrix'
description: 'Matrix of Tower features and their related dependencies.'
---

# Tower API Versions
## Enterprise
Initial values determined from https://github.com/seqeralabs/nf-tower-cloud/blob/v22.1.0-dalambert_8dadb354/VERSION-API (looking at `-enterprise`-tagged branches).

| Tower Version | Tower API Version | CLI Minimum Version | 
|---------------|-------------------|---------------------|
| v21.12.1      | 1.8.0             | v0.4                |
| v21.12.0      | 1.8.0             | v0.4                |
| v21.10.3      | 1.7.1             | v0.4                |
| v21.10.2      | 1.7.1             | v0.4                |
| v21.10.1      | 1.7.1             | v0.4                |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.06.5      | 1.5.2             | n/a                 |
| v21.04.9      | 1.5.2             | n/a                 |
| v21.04.8      | 1.5.2             | n/a                 |
| v21.04.7      | 1.5.2             | n/a                 |
| v21.04.6      | 1.5.2             | n/a                 |
| v21.04.5      | 1.5.2             | n/a                 |
| v21.04.4      | 1.5.2             | n/a                 |
| v21.04.3      | 1.5.2             | n/a                 |
| v21.04.2      | 1.5.2             | n/a                 |
| v21.04.1      | 1.5.2             | n/a                 |
| v21.04.0      | 1.5.2             | n/a                 |


## Tower Cloud
| Tower Version | Tower API Version | CLI Minimum Version | 
|---------------|-------------------|---------------------|
| v22.1.0-edison_1537163d      | 1.9.0             | v0.4     |
| v22.1.0-dalambert_98791828   | 1.9.0             | v0.4     |
| v22.1.0-dalambert_8dadb354   | 1.9.0             | v0.4     |


CLI 0.5.1 needs 1.7 as per https://github.com/seqeralabs/tower-cli/blob/v0.5.1/VERSION-API
CLI 0.5 and 0.4 also need 1.7
v0.3 / 0.2 / 01 needs 1.6
v


## Tower Launcher Version

Based on documentation on at variations of this path: https://github.com/seqeralabs/nf-tower-cloud/blob/v21.12.3-enterprise/tower-services/src/main/groovy/io/seqera/tower/service/TowerServiceImpl.groovy 

| Tower Version | Launcher Version  |
|---------------|-------------------|
| v22.1.0-faggin_63f78620    | quay.io/seqeralabs/nf-launcher:j11-22.03.0-edge          |
| v21.12.3-enterprise    | quay.io/seqeralabs/nf-launcher:j17-21.10.6           |
| v21.12.2-enterprise    | quay.io/seqeralabs/nf-launcher:j17-21.10.6           |
| v21.12.1-enterprise    | quay.io/seqeralabs/nf-launcher:j17-21.10.4           |
| v21.10.4-enterprise    | quay.io/seqeralabs/nf-launcher:j11-21.10.6          |
| v21.10.3-enterprise    | quay.io/seqeralabs/nf-launcher:21.10.5         |
| v21.10.2-enterprise    | quay.io/seqeralabs/nf-launcher:21.10.5         |
| v21.10.1-enterprise    | quay.io/seqeralabs/nf-launcher:21.10.4         |
| v21.10.0-enterprise    | quay.io/seqeralabs/nf-launcher:21.10.4         |



# Functionality Matrix

This page lists the features available in Nextflow Tower and the necessary related infrastructure.

| Feature | Tower Version | Tower API Version | CLI Version | Nextflow Version | Nextflow Launcher Version | Notes |
|---------|---------------|-------------------|-------------|------------------|---------------------------|-------|
| EFS as work directory | 21.12.x | ??? | ??? | ??? | ??? | See [Release Notes](https://install.tower.nf/21.12/release_notes/21.12/#minor-changes-improvements) |
| FSX as work directory | 21.12.x | ??? | ??? | ??? | ??? | See [Release Notes](https://install.tower.nf/21.12/release_notes/21.12/#minor-changes-improvements) |
| Default Retry Policy for AWS Spot Instances | ??? | ??? | ??? | ??? | ??? | ??? |


?? XPack
?? Nextflow Plugins
Administration Panel
?? IARC ENABLE_ROOT_USERS *(behaviour changed in one of the versions- 21.12.x patch? ) https://github.com/seqeralabs/support-backlog/issues/46

* Secrets
* CloudWatch Unified Agent
* EBS Autoscaling permission
* Nextflow Tower Enterprise integration with local git repostiory (22.1.?) .

To do:
- add SecretsManager permissions to Tower permissions list.
- add EBS Autoscaling (KMS) permissions to Tower permissions list.
- Automatic retry for jobs runs against AWS Batch (due to spot reclamation). Waiting for confirmation whether only against Batch clusters created by Tower Forge or any pipeline invoked (https://github.com/seqeralabs/nf-tower-cloud/pull/2820)
* NextRNA AES-256 encryption write to S3 https://git.seqera.io/nextrna/nf-support/issues/11#issuecomment-8508

- ECS pull behaviour - AWS Batch Forge created in v22.01+ will be configured to pull the image only once to each EC2 instance (as per https://github.com/seqeralabs/nf-tower-cloud/issues/2661)
