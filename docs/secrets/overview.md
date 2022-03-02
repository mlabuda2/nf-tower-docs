---
title: Secrets Overview
headline: 'Secrets'
description: 'Step-by-step instructions to set up user and workspace secrets in Nextflow Tower.'
---

## Introduction

Tower uses the concept of **Secrets** to store the keys and tokens that are not meant to be exposed or to be transferred between the platform and the compute environment. In order to achieve this extra level of security, Tower relies on Secrets Manager technology that Cloud providers offers in order to maintain the traffic between the Compute Environment and the vault secure.

!!! note 
    Currently only Slurm/HPC and AWS are supported. Please read more about AWS Secret Manager [here](https://docs.aws.amazon.com/secretsmanager/index.html)

## Workspace Secrets

To create a Workspace Secret is necessary to navigate to a workspace first (private or shared). From there a new tab **Secret** in the top navigation will give access to the secrets management interface.

![](_images/workspace_secrets_and_credentials.png)

The UI shows the list of available secrets and gives allowed users (admin or owner of the workspace) the possibility to create a new secret or update an existing secret value

![](_images/secrets_list.png)

The form for creating or edit a secret is very similar to the one used for credentials.

![](_images/secrets_creation_form.png)

## User Secrets

The User Secrets list and edit/create form works in the same way as the one described above. The menu that appears clicking the avatar in the top right corner gives access to the functionality

![](_images/personal_secrets_and_and_credentials.png)

## Secrets Usage in Pipeline Runs

When a new pipeline is launched then all the secrets (workspace and user) are sent to the corresponding compute environment secret manager: nextflow execution will then download these secrets internally and uses these when referenced in the pipeline code.

When the pipeline reaches its end (indipendently of the positive or negative outcome) then the secrets are automatically deleted from the secrets manager.

## Aws Secrets Manager Integration

If you are planning to use the Pipeline Secrets feature provided by Tower, the following [repo](https://github.com/seqeralabs/nf-tower-aws) explains the modifications to the IAM Permissions.