---
title: Docker container registry credentials
headline: "Docker container credentials"
description: "Step-by-step instructions to set up Docker container registry credentials in Nextflow Tower."
---

### Container registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

Docker Hub makes use of Personal Access Tokens for authentication. Note that we do not currently support Docker Hub authentication using 2FA (two-factor authentication).

To create your new Docker Hub registry credential in Tower, follow these steps:

**1.** Create a [Personal Access Token](https://docs.docker.com/docker-hub/access-tokens/) for your user account in Docker Hub.

**2.** (In Tower) From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

**3.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores.

**4.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed:

![](_images/container_registry_credentials_blank.png)

**5.** Enter the Docker username in the **User name** field.

**6.** Enter the Personal Access Token in the **Password** field.

**7.** (Optional) Enter `docker.io` in the **Registry server** field.

**8.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**9.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
