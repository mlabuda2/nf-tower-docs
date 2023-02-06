---
description: 'Introduction to Workspaces.'
---

Each user has a unique workspace where they can interact and manage all resources, such as pipelines, compute environments, and credentials.

!!! tip
    You can create multiple workspaces within an organization context and associate each of these workspaces with dedicated teams of users, while providing a fine-grained access control model for each of the teams. Refer to the [Orgs and Teams](../orgs-and-teams/overview.md) section.

The core components of a workspace are described below.

## Launchpad

The **Launchpad** offers a streamlined UI for launching and managing pipelines along with their associated compute environments and credentials. Using the Launchpad, you can create a curated set of pipelines (including variations of the same pipeline) which are ready to be executed on the associated compute environments, while allowing the user to customize the pipeline-level parameters if needed.

## Runs

The **Runs** section monitors a launched workflow with real-time execution metrics, such as the number of pending or completed processes. See [Launch](../launch/launch.md).

## Actions

You can trigger pipelines based on specific events, such as a version release on Github or a general Tower webhook. See [Pipeline Actions](../pipeline-actions/overview.md).

## Compute Environments

Tower uses the concept of a **Compute Environment** to define an execution platform for pipelines. Tower supports launching pipelines into a growing number of cloud (AWS, Azure, GCP) and on-premise (Slurm, IBM LSF, Grid Engine, etc). infrastructures. See [Compute Environments](../compute-envs/overview.md) for more information.

## Credentials

The **Credentials** section allows users to set up the access credentials for various platforms (Github, Gitlab and BitBucket) as well as various compute environments such as cloud, Slurm  or Kubernetes, etc. See [Compute Environments](../compute-envs/overview.md) and [Git Integration](../git/overview.md) for information on your infrastructure. See [Credentials](../credentials/overview.md) for more details.
