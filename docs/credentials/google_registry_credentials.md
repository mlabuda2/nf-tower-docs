---
title: Google Cloud Artifact Registry credentials
headline: 'Google Cloud Artifact Registry credentials'
description: 'Step-by-step instructions to set up Google Cloud Artifact Registry credentials in Nextflow Tower.'
---

### Registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. Google Cloud Artifact Registry is fully integrated with Google Cloud services and integration with third party tools can be configured, so authentication depends on how your Artifact Registry repository is configured. For further details, see [Google Artifact Registry access control](https://cloud.google.com/artifact-registry/docs/access-control). 

To create your new registry credential in Tower, follow these steps:

**1.** Create a [Google Service account key](https://cloud.google.com/artifact-registry/docs/docker/authentication#json-key) that has permissions to access Google Artifact Registry. 

**2.** Navigate to the Credentials tab in Tower and select **Add Credentials**. 

**3.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**4.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**5.** Enter `_json_key_base64` in the **User name** field.

**6.** Enter the base64-encoded JSON key content in the **Password** field. 

**7.** Enter your registry hostname in the **Registry server** field.

**8.** Select **Add**. The new credential is now listed under the **Credentials** tab.