---
title: AWS ECR credentials
headline: "AWS ECR credentials"
description: "Step-by-step instructions to set up AWS ECR credentials in Nextflow Tower."
---

## Registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

### AWS ECR access

AWS ECR (Elastic Container Registry) grants access to users based on IAM roles and permissions.

Tower requires programmatic access to your private registry using [long-term access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#create-long-term-access-keys).

Long-term access keys with elevated permissions are a potential security risk. Do not create access keys for your AWS root user, as this user can access any resource in your AWS account, including billing information.

An IAM administrator can create and manage access keys from the AWS management console:

1. Open the [IAM console](https://console.aws.amazon.com/iam/).
2. Select **Users** from the navigation pane.
3. Select the name of the user whose keys you want to manage, then select the **Security credentials** tab. We recommend creating an IAM user specifically for Tower authentication instead of using existing credentials with broader permissions.
4. In the **Access keys** section, select **Create access key**. Each IAM user can have only two access keys at a time, so if the Create option is deactivated, delete an existing access key first.
5. On the **Access key best practices & alternatives** page, select **Other** and then **Next**.
6. On the **Retrieve access key** page, you can either **Show** the user's secret access key details, or store them by selecting **Download .csv file**.
7. The newly created access key pair is active by default and can be stored as a container registry credential in Tower.

!!! note
Your credential must be stored in Tower as a **container registry** credential, even if the same access keys already exist in Tower as a [workspace credential](./workspace_credentials.md).

### Add credentials to Tower

- From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

- From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

![](_images/container_registry_credentials_blank.png)

| Property        | Description                                                                             | Example                                                   |
| --------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| Name            | A unique name for the credentials using alphanumeric characters, dashes, or underscores | `my-registry-creds`                                       |
| Provider        | Credential type                                                                         | Container registry                                        |
| User name       | IAM user access key ID                                                                  | `AKIAIOSFODNN7EXAMPLE`                                    |
| Password        | IAM user secret access key                                                              | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`                |
| Registry server | The container registry server name                                                      | `https://<aws_account_id>.dkr.ecr.<region>.amazonaws.com` |

Once the form is complete, select **Add**. The new credential is now listed under the **Credentials** tab.

!!! note
In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
