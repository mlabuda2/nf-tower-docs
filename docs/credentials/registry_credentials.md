---
title: Container registry credentials
headline: 'Container registry credentials'
description: 'Step-by-step instructions to set up container registry credentials in Nextflow Tower.'
---

## Introduction

From version 22.4, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registry services, such as Docker Hub, Google Artifact Registry, Quay, etc. For more information on Wave containers, see [here](https://www.nextflow.io/blog/2022/rethinking-containers-for-cloud-native-pipelines.html). 

### General instructions

Using credentials or keys with permissions to access your registry, you can create container registry credentials in Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials to be used to access the container registry, starting with the **User name**.

**5.** Enter the container registry credential **Password**. For registry authentication using keys (such as the JSON key file for Google Artifcate Registry), populate this field with the (base64-encoded) key content. 

**6.** Enter the container **Registry server** name. If left blank, _docker.io_ will be used by default.  

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.
