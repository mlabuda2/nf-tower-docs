---
title: AWS ECR credentials
headline: "AWS ECR credentials"
description: "Step-by-step instructions to set up AWS ECR credentials in Nextflow Tower."
---

### Registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

AWS ECR (Elastic Container Registry) grants access to users based on IAM roles and permissions. Use [long-term access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#create-long-term-access-keys) of an IAM user with appropriate permissions to authenticate Tower to your registry. Your credential must be stored in Tower as a **container registry** credential, even if the same access keys already exist in Tower as a [workspace credential](./workspace_credentials.md).

Once you have set up an IAM user with permissions to access your ECR registry, add the user's credentials to Tower:

- From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

- From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

![](_images/container_registry_credentials_blank.png)

**4.** Enter the user access key ID in the **User name** field.

**5.** Enter the user secret access key in the **Password** field.

![](_images/container_registry_credentials_blank.png)

| Property        | Description                                                                             | Example                                                   |
| --------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| Name            | A unique name for the credentials using alphanumeric characters, dashes, or underscores | my-registry-creds                                         |
| Provider        | Credential type                                                                         | Container registry                                        |
| User name       | IAM user access key ID                                                                  | `AKIAIOSFODNN7EXAMPLE`                                    |
| Password        | IAM user secret access key                                                              | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`                |
| Registry server | The container registry server name                                                      | `https://<aws_account_id>.dkr.ecr.<region>.amazonaws.com` |

Once the form is complete, select **Add**. The new credential is now listed under the **Credentials** tab.

!!! note
In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
