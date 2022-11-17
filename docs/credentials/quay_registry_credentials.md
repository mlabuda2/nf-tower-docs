---
title: Quay container registry credentials
headline: 'Quay container registry credentials'
description: 'Step-by-step instructions to set up Quay container credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

For Quay repositories, we recommend using [robot accounts](https://docs.quay.io/glossary/robot-accounts.html) for authentication. Once set up with appropriate permissions, add the robot account's credentials to Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the robot account username (in the format `namespace+accountname`, i.e. `mycompany+deploy`) in the **User name** field. 

**5.** Enter the robot account access token (found by selecting the robot account in your Quay admin panel) in the **Password** field. 

**6.** Enter your registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**8.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file. 
