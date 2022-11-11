---
title: Azure container registry credentials
headline: 'Azure container credentials'
description: 'Step-by-step instructions to set up Azure container registry credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

Azure container registry makes use of Azure RBAC (Role-Based Access Control) to grant users access — for further details, see [Azure container registry roles and permissions](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-roles). 

Once you have granted a user the appropriate permissions to access your registry, Azure provides a number of options for authenticating to the registry (such as [individual login or Azure AD](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli)). Using the access token you created with the Azure CLI commands described in the articles above, the registry credentials can be configured in Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter `00000000-0000-0000-0000-000000000000` in the **User name** field. 

**5.** Enter the access token (`accessToken` — received when the `az acr login` command was run) in the **Password** field. 

**6.** Enter the container registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**8.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` to the **Nextflow config** field on the launch page. 