---
title: Google Cloud Artifact Registry credentials
headline: 'Google Cloud Artifact Registry credentials'
description: 'Step-by-step instructions to set up Google Cloud Artifact Registry credentials in Nextflow Tower.'
---

### Registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. Google Cloud Artifact Registry is fully integrated with Google Cloud services and integration with third party tools can be configured, so authentication depends on how your Artifact Registry repository is configured. For further details, see [Google Artifact Registry access control](https://cloud.google.com/artifact-registry/docs/access-control). Registry credentials can be configured in Tower from the Credentials tab:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the details of the Artifact Registry service account — with the appropriate IAM role to access the registry — using the **User name** and **Password** fields.

**6.** Enter your registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.