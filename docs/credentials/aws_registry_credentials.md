---
title: AWS ECR credentials
headline: 'AWS ECR credentials'
description: 'Step-by-step instructions to set up AWS ECR credentials in Nextflow Tower.'
---

### Registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

AWS ECR makes use of IAM user roles for access control. Note that [long-term access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#create-long-term-access-keys) must be used to authenticate Tower to your registry. This must be stored as a **Container registry** credential, even if the same access keys already exist in Tower as a [workspace credential](./workspace_credentials.md). Once you have set up an IAM user with permissions to access your ECR registry, add the user's credentials to Tower using these steps:

**1.** Navigate to the Credentials tab and select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the user access key ID in the **User name** field. 

**5.** Enter the user secret access key in the **Password** field. 

**6.** Enter your registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.

**8.** In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file. 