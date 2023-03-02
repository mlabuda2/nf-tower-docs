---
title: Azure container registry credentials
headline: "Azure container credentials"
description: "Step-by-step instructions to set up Azure container registry credentials in Nextflow Tower."
---

### Container registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

Azure container registry makes use of Azure RBAC (Role-Based Access Control) to grant users access — for further details, see [Azure container registry roles and permissions](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-roles).

You must use Azure credentials with long-term registry access to authenticate Tower to your registry.

To create the container registry credentials in Tower, follow these steps:

**1.** In the Azure container registry portal, enable the Admin user for your registry from **Settings > Access keys**.

**2.** (In Tower) From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

**3.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores.

**4.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed:

![](_images/container_registry_credentials_blank.png)

**5.** Enter the admin user's username in the **User name** field.

**6.** Enter the admin user password in the **Password** field.

**7.** Enter the container registry hostname in the **Registry server** field. This is the **Login server** name on your container registry's **Settings > Access keys** page in Azure portal.

**8.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**9.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
