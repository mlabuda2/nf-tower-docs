---
title: Credentials Overview
headline: 'Credentials'
description: 'Step-by-step instructions to set up credentials in Nextflow Tower.'
---

## Introduction

Tower uses the concept of **Credentials** to store the access keys and tokens for your [Compute Environments](../compute-envs/overview.md) and [Git hosting services](../git/overview.md). Detailed instructions for adding credentials can be found on the page for each compute environment and in the Git Integration section. 


![](_images/credentials_overview.png)

!!! note 
    All credentials are encrypted using AES-256 before secure storage and never exposed by any Tower API.

### User credentials

1. Select **Add Credentials**. 
2. Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 
3. From the **Provider** drop-down list, select the provider the credentials will be used for. The **New Credentials** form displays additional fields to be completed based on your choice. 

### Container registry credentials 

From version 22.4, Tower supports the configuration of credentials for these container registry services:

- AWS ECR
- Azure
- Docker
- Google Artifactory
- Quay 

 These credentials can be created from the Credentials tab using these steps:


1. Select **Add Credentials**. 
2. Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 
3. From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

4. Enter the credentials to be used to access the container registry, starting with the **User name**.
5. Enter the container registry credential **Password**.
6. Enter the container **Registry server** name. If left blank, _docker.io_ will be used by default.  

