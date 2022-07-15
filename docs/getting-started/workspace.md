---
description: 'Introduction to Workspaces.'
---

Each user has a unique workspace where they can interact and manage all resources such as pipelines, compute environments and credentials.

!!! tip
    It is also possible to create multiple workspaces within an organization context and associate each of these workspaces with dedicated teams of users, while providing a fine-grained access control model for each of the teams. Please refer to the [Orgs and Teams](../orgs-and-teams/overview.md) section.

The core components of a workspace are described below.

## Launchpad

The **Launchpad** offers a streamlined UI for launching and managing pipelines along with their associated compute environments and credentials. Using the Launchpad, it is possible to create a curated set of pipelines (including variations of the same pipeline) which are ready to be executed on the associated compute environments, while allowing the user to customize the pipeline-level parameters if needed.

## Runs

The **Runs** section is used for monitoring a launched workflow with real-time execution metrics such as the number of pending or completed processes. For more information please refer to the [Launch](../launch/launch.md) section.

## Actions

It is possible to trigger pipelines based on specific events such as a version release on Github or general Tower webhook. For more information please refer to the [Pipeline Actions](../pipeline-actions/overview.md) section.

## Compute Environments

Tower uses the concept of a **Compute Environment** to define an execution platform for pipelines. Tower supports launching pipelines into a growing number of cloud (AWS, Azure, GCP) and on-premises (Slurm, IBM LSF, Grid Engine, etc). infrastructures. For more information, please refer to the [Compute Environments](../compute-envs/overview.md) section.

## Credentials

The **Credentials** section allows users to set up the access credentials for various platforms (Github, Gitlab and BitBucket) as well as various compute environments such as cloud, Slurm  or Kubernetes, etc. Please refer to the [Compute Environment](../compute-envs/overview.md) and [Git Integration](../git/overview.md) sections for instructions regarding your infrastructure. For more information, please refer to the [Credentials](../credentials/overview.md) section.
