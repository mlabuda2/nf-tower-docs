---
layout: ../../layouts/HelpLayout.astro
title: "Secrets"
description: "Instructions to use secrets in Tower."
date: "24 Apr 2023"
tags: [pipeline, secrets]
---

Tower uses **secrets** to store the keys and tokens used by workflow tasks to interact with external systems, e.g., a password to connect to an external database or an API token. Tower relies on third-party secret manager services in order to maintain security between the workflow execution context and the secret container. This means that no secure data is transmitted from Tower to the compute environment.

!!! note 
    Currently, AWS Batch and HPC batch schedulers are supported. See [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/index.html) for more information. 

### Pipeline secrets

To create a pipeline secret, navigate to a workspace (private or shared) and select the **Secrets** tab in the top navigation bar.

![](_images/workspace_secrets_and_credentials.png)

Available secrets will be listed here and users with the appropriate permissions (maintainer, admin, or owner) will be able to create or update secret values.

![](_images/secrets_list.png)

The form for creating or updating a secret is similar to the credentials form.

![](_images/secrets_creation_form.png)

### User secrets

Secrets can be defined for users by opening the user top-right menu and selecting "Your Secrets". Listing, creating, and updating secrets for users is the same as secrets in a workspace.

![](_images/personal_secrets_and_and_credentials.png)

<!-- prettier-ignore -->
!!! warning
    Secrets defined by a user have higher priority and will override any secrets defined in a workspace with the same name.

### Using secrets in workflows

When a new workflow is launched, all secrets are sent to the corresponding secrets manager for the compute environment. Nextflow will download these secrets internally and use them when referenced in the pipeline code. See [Nextflow secrets](https://www.nextflow.io/docs/edge/secrets.html#process-secrets) for more information.

Secrets will be automatically deleted from the secret manager when the pipeline completes, successfully or unsuccessfully.

## AWS Secrets Manager integration
Tower and associated AWS Batch IAM Roles require additional IAM permissions to interact with AWS Secrets Manager.

### Tower instance permissions
Augment the existing Tower instance [permissions](https://github.com/seqeralabs/nf-tower-aws) with this policy:

=== "IAM Permissions"
    1. Augment the permissions given to Tower with the following Sid:
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowTowerEnterpriseSecrets",
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:DeleteSecret",
                    "secretsmanager:ListSecrets",
                    "secretsmanager:CreateSecret"
                ],
                "Resource": "*"
            }
        ]
    }
    ```

### ECS Agent permissions
The ECS Agent uses the [Batch Execution role](https://docs.aws.amazon.com/batch/latest/userguide/execution-IAM-role.html#create-execution-role) to communicate with AWS Secrets Manager.

1. If your AWS Batch compute environment does not have an assigned execution role, create one.
2. If your AWS Batch compute environment already has an assigned execution role, augment it.

=== "IAM permissions"
    1. Add the [`AmazonECSTaskExecutionRolePolicy` managed policy](https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonECSTaskExecutionRolePolicy.html).

    2. Add this inline policy:
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowECSAgentToRetrieveSecrets",
                "Action": [
                    "secretsmanager:GetSecretValue"
                ],
                "Resource": [
                    "arn:aws:secretsmanager:<YOUR_COMPUTE_REGION>:*:secret:*"
                ],
                "Effect": "Allow"
            }
        ]
    }
    ```

=== "IAM trust relationship"
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowECSTaskAssumption",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

### Compute permissions
The Nextflow Head job must communicate with the AWS Secrets Manager. Its permissions come from either a custom role assigned during the [AWS Batch CE creation process](https://help.tower.nf/compute-envs/aws-batch/#advanced-options), or are inherited from its host [EC2 instance](https://docs.aws.amazon.com/batch/latest/userguide/instance_IAM_role.html). 

Augment your Nextflow Head job permission source with the following policy.

=== "EC2 Instance Role"
    1. Add the following policy to your EC2 Instance Role:
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowNextflowHeadJobToAccessSecrets",
                "Effect": "Allow",
                "Action": "secretsmanager:ListSecrets",
                "Resource": "*"
            }
        ]
    }
    ```

=== "Custom IAM role"
    1. Add the following policy to your custom IAM Role
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowNextflowHeadJobToAccessSecrets",
                "Effect": "Allow",
                "Action": "secretsmanager:ListSecrets",
                "Resource": "*"
            },
            {
                "Sid": "AllowNextflowHeadJobToPassRoles",
                "Effect": "Allow",
                "Action": [
                    "iam:GetRole",
                    "iam:PassRole"
                ],
                "Resource": "arn:aws:iam::YOUR_ACCOUNT:role/YOUR_BATCH_CLUSTER-ExecutionRole"
            }
        ]
    }
    ```

    2. Add the following trust policy to your custom IAM role:
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowECSTaskAssumption",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```