---
title: Secrets Overview
headline: 'Secrets'
description: 'Step-by-step instructions to set-up User and Workspace Secrets in Nextflow Tower.'
---

## Introduction

Tower uses the concept of **Secrets** to store the keys and tokens that are not meant to be exposed or to be transferred between the platform and the compute environment. In order to achieve this extra level of security, Tower relies on Secrets Manager technology that Cloud providers offers in order to maintain the traffic between the Compute Environment and the vault secure.

!!! note 
    Currently only Slurm/HPC and AWS are supported. Please read more about AWS Secret Manager [here](https://docs.aws.amazon.com/secretsmanager/index.html)

## Workspace Secrets

To create a Workspace-level Secret navigate to a Workspace (private or shared) and click on the **Secrets** tab in the top navigation pane to gain access to the Secrets management interface.

![](_images/workspace_secrets_and_credentials.png)

All of the available Secrets will be listed here and users with the appropriate permissions (Workspace admin or owner) will be able to create or update Secret values.

![](_images/secrets_list.png)

The form for creating or updating a Secret is very similar to the one used for Credentials.

![](_images/secrets_creation_form.png)

## User Secrets

User-level Secrets can be accessed by clicking on your avatar in the top right corner of the Tower interface and selecting "Your Secrets". Conceptually, listing, creating and updating User-level Secrets is the same as highlighted for Workspace-level Secrets. 

![](_images/personal_secrets_and_and_credentials.png)

## Secrets Usage in Pipeline Runs

When a new Pipeline is launched then all Secrets (Workspace and User) are sent to the corresponding Secrets Manager for the Compute Environment: On executions, Nextflow will download these Secrets internally and uses them wherever they are referenced in the pipeline code.

Secrets will be automatically deleted from the Secrets Manager when the Pipeline reaches completion (successful or unsuccessful).