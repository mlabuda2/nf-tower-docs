---
title: Google Cloud Artifact Registry and Container Registry credentials
headline: 'Google Cloud Artifact Registry and Container Registry credentials'
description: 'Step-by-step instructions to set up Google Cloud Artifact Registry and Container Registry credentials in Nextflow Tower.'
---

### Registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

Google Cloud Artifact Registry and Google Cloud Container Registry are fully integrated with Google Cloud services and support various authentication methods. Note that long-lived service account keys (in the form of JSON key files) must be used to authenticate Tower to your registry. For more information, see [Container Registry authentication](https://cloud.google.com/container-registry/docs/advanced-authentication#json-key) or [Artifact Registry authentication](https://cloud.google.com/artifact-registry/docs/docker/authentication#json-key).

To create your new registry credential in Tower, follow these steps:

**1.** Create a Google Service account key that has permissions to access your registry (see the Google registry-specific guides linked above). 

**2.** Navigate to the Credentials tab in Tower and select **Add Credentials**. 

**3.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**4.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**5.** Enter `_json_key_base64` in the **User name** field.

**6.** Enter the base64-encoded JSON key content in the **Password** field. 

**7.** Enter your registry hostname in the **Registry server** field.

**8.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**9.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file. 