---
title: Docker container registry credentials
headline: 'Docker container credentials'
description: 'Step-by-step instructions to set up Docker container registry credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registry services. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

To create your new Docker Hub registry credential in Tower, follow these steps:

**1.** Create a [Personal Access Token](https://docs.docker.com/docker-hub/access-tokens/) for your user account in Docker Hub.

**2.** In Tower, navigate to the Credentials tab and select **Add Credentials**. 

**3.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**4.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**5.** Enter the credentials to be used to access the container registry, starting with the **User name**.

**6.** Enter the Personal Access Token in the **Password** field.

**7.** (Optional) Enter _docker.io_ in the **Registry server** field.

**8.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**9.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` to the **Nextflow config** field on the launch page. 