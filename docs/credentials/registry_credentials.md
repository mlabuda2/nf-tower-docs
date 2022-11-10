---
title: Container registry credentials
headline: 'Container registry credentials'
description: 'Step-by-step instructions to set up container registry credentials in Nextflow Tower.'
---

## Introduction

From version 22.4, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Wave container service to authenticate to private container registry services, such as Docker Hub, Google Artifact Registry, Quay, etc. 

### General instructions

Container registry credentials can be created from the Credentials tab using these steps:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials to be used to access the container registry, starting with the **User name**.

**5.** Enter the container registry credential **Password**.

**6.** Enter the container **Registry server** name. If left blank, _docker.io_ will be used by default.  

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.
