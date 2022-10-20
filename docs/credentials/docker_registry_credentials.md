---
title: Docker container registry credentials
headline: 'Docker container credentials'
description: 'Step-by-step instructions to set up Docker container registry credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. Docker Hub container credentials make use of [Personal Access Tokens](https://docs.docker.com/docker-hub/access-tokens/). Your Docker Hub credentials can be configured in Tower from the Credentials tab:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials to be used to access the container registry, starting with the **User name**.

**5.** Enter the Personal Access Token in the **Password** field.

**6.** (Optional) Enter _docker.io_ in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.
