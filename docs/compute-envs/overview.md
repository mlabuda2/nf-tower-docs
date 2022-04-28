---
description: 'Overview of compute environments in Nextflow Tower.'
---

## Introduction

Tower uses the concept of **Compute Environments** to define the execution platform where a pipeline will run. 

It supports launching pipelines into a growing number of **cloud** and **on-premise** infrastructures.

![](_images/compute_env_platforms.png)

Each compute environment must be pre-configured to enable Tower to submit tasks. You can read more on how to set up each environment using the links below.


## Platforms

The following pages describe how to set up a compute environment for each of the available platforms.

* [AWS Batch](./aws-batch.md)
* [Azure Batch](./azure-batch.md)
* [Google Cloud](./google-cloud.md)
* [Altair Grid Engine](./altair-grid-engine.md)
* [Altair PBS Pro](./altair-pbs-pro.md)
* [IBM LSF](./lsf.md)
* [Slurm](./slurm.md)
* [Kubernetes](./k8s.md)
* [Amazon EKS](./eks.md)
* [Google GKE](./gke.md)


## Select a default compute environment

If you have more than one compute environment, you can select which one will be used by default when launching a pipeline.

1. In a workspace, select **Compute Environments**.

2. Select **Make primary** for a particular compute environment to make it your default.   

!!! tip "Congratulations!" 
    You are now ready to launch pipelines with your primary compute environment.