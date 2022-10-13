---
title: AWS ECR credentials
headline: 'AWS ECR credentials'
description: 'Step-by-step instructions to set up AWS ECR credentials in Nextflow Tower.'
---

### Registry credentials 

From version 22.3, Tower supports the configuration of credentials for container registry services. AWS ECR makes use of IAM user roles for access control, so authentication depends on how your ECR instance is configured and used. For further details, see [ECR Identity and Access Management](https://docs.aws.amazon.com/AmazonECR/latest/userguide/security-iam.html). ECR user credentials can be configured in Tower from the Credentials tab:

**1.** Select **Add Credentials**. 

**2.** Enter a unique name in the **Name** field using alphanumeric characters, dashes, or underscores. 

**3.** From the **Provider** drop-down list, select **Container registry**. The New Credentials form now displays additional fields to be completed: 

![](_images/container_registry_credentials_blank.png)

**4.** Enter the details of the AWS user — with the appropriate IAM role to access the registry — using the **User name** and **Password** fields.

**6.** Enter your registry hostname in the **Registry server** field.

**7.** Select **Add**. The new credential is now listed under the **Credentials** tab.