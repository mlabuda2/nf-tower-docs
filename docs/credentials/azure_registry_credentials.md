---
title: Azure container registry credentials
headline: 'Azure container credentials'
description: 'Step-by-step instructions to set up Azure container registry credentials in Nextflow Tower.'
---

### Container registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. Azure container registry grants access to users with appropriate permissions — for further details, see [Azure container registry roles and permissions](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-roles). These credentials can be configured in Tower from the Credentials tab using these steps:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the credentials — to be used to access the container registry — starting with the **User name**.

**5.** Enter the Access Key in the **Password** field.

**6.** Enter the container registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.