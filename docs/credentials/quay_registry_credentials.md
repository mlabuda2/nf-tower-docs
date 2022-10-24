---
title: Quay container registry credentials
headline: 'Quay container registry credentials'
description: 'Step-by-step instructions to set up Quay container credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. Quay credentials depend on the authentication specified in your [Quay configuration](https://access.redhat.com/documentation/en-us/red_hat_quay) and are used to authenticate to your Quay deployment. Your Quay credentials can be configured in Tower from the Credentials tab:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials configured in your `config.yaml` file in the **User name** and **Password** fields.

**5.** Enter your server hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.
