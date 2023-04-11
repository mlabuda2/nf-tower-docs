---
title: Secrets Overview
headline: "Secrets"
description: "Step-by-step instructions to set-up Secrets in Tower."
---

## Overview

Use Tower **secrets** to store the keys and tokens used by workflow tasks to interact with external systems, such as a password to connect to an external database, or an API token. Tower relies on third-party secret manager services to maintain security between the workflow execution context and the secret container. This means that no secure data is transmitted from Tower to the compute environment.

<!-- prettier-ignore -->
!!! note 
    Currently, only AWS Batch and HPC batch schedulers are supported. Learn more about AWS Secrets Manager [here](https://docs.aws.amazon.com/secretsmanager/index.html).

### Create pipeline secrets

-   **Workspace secrets**: from an organization workspace, navigate to the Secrets tab and select **Add pipeline secret**.

-   **User secrets**: from your personal workspace, select **Your secrets** from the user top-right menu, then select **Add pipeline secret**.

<!-- prettier-ignore -->
!!! note
    Secrets can only be used with pipelines in organization workspaces (private or shared). Pipelines in personal workspaces do not support pipeline secrets.

![](_images/workspace_secrets_and_credentials.png)

All available secrets will be listed here and users with a maintainer, admin, or owner role will be able to create or update secret values.

![](_images/secrets_list.png)

The form for creating or updating a Secret is very similar to the one used for Credentials.

![](_images/secrets_creation_form.png)

### Pipeline secrets for users

Secrets can be defined for users by selecting **Your secrets** from the user top-right menu. Listing, creating and updating secrets for users is identical to secrets in a workspace.

<!-- prettier-ignore -->
!!! warning
    Secrets defined by a user have higher priority and will override any secrets defined in a workspace with the same name.

### Using secrets in workflows

When a new workflow is launched, all secrets are sent to the corresponding secret manager for the compute environment. Nextflow will download these secrets internally and use them when they are referenced in the pipeline code, as described in [Nextflow secrets](https://www.nextflow.io/docs/edge/secrets.html#process-secrets).

Secrets are deleted from the secrets manager automatically when the pipeline completes (whether successful or not).

### AWS Secrets Manager integration

If you intend to use Tower pipeline secrets with the AWS Secrets Manager, the following IAM permissions are required:

1. Create the AWS Batch [IAM Execution role](https://docs.aws.amazon.com/batch/latest/userguide/execution-IAM-role.html#create-execution-role).

2. Add [this custom policy](../_templates/aws-batch/secrets-policy-execution-role.json){:target='\_blank'} to the Batch execution role.

3. Specify the execution role ARN in the **Batch execution role** option (under **Advanced options**) when creating your Tower compute environment.

4. Add [this custom policy](../_templates/aws-batch/secrets-policy-instance-role.json){:target='\_blank'} to the ECS Instance role associated with the Batch compute environment that will be used to deploy your pipelines. Replace `YOUR-ACCOUNT` and `YOUR-EXECUTION-ROLE-NAME` with the appropriate values. See [here](https://docs.aws.amazon.com/batch/latest/userguide/instance_IAM_role.html) for more details about the Instance role.

5. Add [this custom policy](../_templates/aws-batch/secrets-policy-account.json){:target='\_blank'} to your Tower IAM user (the one specified in the Tower credentials).
