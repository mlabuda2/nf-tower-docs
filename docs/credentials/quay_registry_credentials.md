---
title: Quay container registry credentials
headline: 'Quay container registry credentials'
description: 'Step-by-step instructions to set up Quay container credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

You grant users access to your Quay deployment using the AUTHENTICATION_TYPE specified in your [Quay configuration](https://docs.projectquay.io/config_quay.html#config-fields-required-general). Once set up, add the  credentials of a user with appropriate Quay access to Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the user's credentials to the **User name** and **Password** fields.

**5.** Enter your server hostname in the **Registry server** field.

**6.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**7.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file. 
