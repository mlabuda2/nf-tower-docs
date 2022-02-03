---
title: Amazon EKS
headline: 'Amazon EKS Compute environment'
description: 'Step-by-step instructions to set up a Tower compute environment for Amazon EKS clusters'
---
## Overview

[Amazon EKS](https://aws.amazon.com/eks/) is a managed Kubernetes cluster that allows the execution of containerized workloads in the AWS cloud at scale.

Nextflow Tower offers native support for AWS EKS clusters and streamlines the deployment of Nextflow pipelines in such environments.

## Requirements

You need to have an EKS cluster up and running. Make sure you have followed the steps in the [Cluster preparation](https://github.com/seqeralabs/nf-tower-k8s/blob/master/cluster-preparation.md) guide to create the cluster resources required by Nextflow Tower.


## Compute environment setup  

**1.** In a workspace choose "**Compute environments**" and then, click on the **New Environment** button.

**2.** Provide a name for this environment, for example, *Amazon EKS (us-east-1)*.

**3.** Select **Amazon EKS** as the target platform.

![](_images/eks_new_env.png) 

**4.** Select your AWS credentials or create new ones. The credentials are needed to identify the user that will access the EKS cluster.

!!! tip 
    Make sure the user has the IAM permissions required to describe and list EKS clusters as explained at [this link](https://github.com/seqeralabs/nf-tower-k8s/blob/master/cluster-preparation.md#4-amazon-eks-specific-setting).

**5.** Specify the AWS *region* where the Kubernetes cluster is located e.g. `us-west-1`.

**6.** The field **Cluster name** lists all EKS clusters available in the selected region. Choose the one you want to use to deploy the Nextflow execution.

**7.** Specify the Kubernetes **Namespace** that should be used to deploy the pipeline execution.

If you have followed the example in the [cluster preparation](https://github.com/seqeralabs/nf-tower-k8s/blob/master/cluster-preparation.md#2-service-account--role-creation) guide, this field should be `tower-nf`.

**8.** Specify the Kubernetes **Head service account** that will be used to grant permissions to Tower to deploy the pod executions.

If you have followed the [cluster preparation](https://github.com/seqeralabs/nf-tower-k8s/blob/master/cluster-preparation.md#2-service-account--role-creation) guide, this field should be `tower-launcher-sa`.

**9.** The **Storage claim** field allows you to specify the storage Nextflow will use as a scratch file system for the pipeline execution.

This should reference a Kubernetes persistence volume with `ReadWriteMany` capability. See the [cluster preparation](https://github.com/seqeralabs/nf-tower-k8s/blob/master/cluster-preparation.md#3-storage-configuration) guide for details.


**10.** You can specify certain environment variables on the Head job or the Compute job using the **Environment variables** option.

![](_images/env_vars.png)



## Advanced options

These options allow for the fine-tuning of the Tower configuration for the EKS cluster.

![](_images/advanced_options.png) 

The following parameters are available:

**1.** The **Storage mount path** defines the file system path where the Storage claim is mounted. 

Default: `/scratch`

**2.** The **Work directory** field defines the file system path used as a working directory by Nextflow pipelines. It must be the same or a subdirectory of the *Storage mount path* at the previous point. 

Default: the same as *Storage mount path*.

**3.** The  **Compute service account** field allows you to specify the Kubernetes *service account* that the pipeline jobs should use. 

Default is the `default` service account in your Kubernetes cluster.

**4.** The pod behavior within the cluster could be controlled by using the **Pod cleanup policy** option.

**5.** The **Custom head pod specs** field allows you to provide a custom configuration for the pod running the Nextflow workflow e.g. `nodeSelector` and `affinity` constraints. It should be a valid PodSpec YAML structure starting with `spec:`.

**6.** The **Custom service pod specs** field allows you to provide a custom configuration for the compute environment service pod e.g. `nodeSelector` and `affinity` constraints. It should be a valid PodSpec YAML structure starting with `spec:`.


Jump to the documentation section for [Launching Pipelines](../launch/launchpad.md).
