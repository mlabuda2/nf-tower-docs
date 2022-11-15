---
title: Container registry credentials
headline: 'Container registry credentials'
description: 'Step-by-step instructions to set up container registry credentials in Nextflow Tower.'
---

## Introduction

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries (such as Docker Hub, Google Artifact Registry, Quay, etc.) For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html). 

### General instructions

Using credentials, access tokens, or keys with permissions to access your registry, you can create container registry credentials in Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials to be used to access the container registry, as described in the page specific to each target registry.

**5.** Enter the container **Registry server** name. If left blank, _docker.io_ will be used by default.  

**6.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**7.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file. 
