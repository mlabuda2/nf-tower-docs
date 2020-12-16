---
title: Amazon EKS
weight: 1
layout: single
publishdate: 2020-10-20 04:00:00 +0000
authors:
  - "Jordi Deu-Pons"
  - "Paolo Di Tommaso"
  - "Alain Coletta"
  - "Seqera Labs"

headline: 'Kubernetes Compute environments'
description: 'Step-by-step instructions to set up a Tower compute environment for Amazon EKS cluster'
menu:
  docs:
    parent: Compute Environments
    weight: 6

---
## Overview

Amazon EKS is a managed Kubernetes cluster that allows to run containerised workloads in the
AWS cloud at scale.

Nextflow Tower offers native support for AWS EKS clusters and streamlines the deployment
of Nextflow pipelines in such environment.

## Requirement

You need to have an EKS cluster up and running. Make sure you have followed
the steps in the [Cluster preparation](https://github.com/seqeralabs/nf-tower-k8s) guide to create the cluster resources required
by Nextflow Tower.


## Compute environment setup  


**1.** In the navigation bar on the upper right, choose your account name then choose **Compute environments** and select **New Environment**.

{{% pretty_screenshot img="/uploads/2020/09/aws_new_env.png" %}}

</br>

**2.** Enter a descriptive name for this environment. For example, *Amazon EKS* and select **Amazon EKS** as the target platform.

{{% pretty_screenshot img="/uploads/2020/12/eks_new_env.png" %}}

**3.** Select your AWS credentials or create new ones.

**4.** Enter the region where the Kubernetes cluster is located.

**5** Enter the **namespace** e.g `tower-nf` like the [examples](#namespace-creation) above.

**6** Enter the **head service account** e.g `tower-launcher-sa` as was set as the [role and service account examples](#service-account-role-creation) above.

**7** Enter the **storage claim** e.g `tower-scratch` as was set in the [storage configuration](#storage-configuration).

{{% pretty_screenshot img="/uploads/2020/12/eks_env_setup.png" %}}

## Staging options

<br>

{{% pretty_screenshot img="/uploads/2020/12/staging_options.png" %}}

You can include pre & post-run scripts to your environment. This custom code will run either before and after the execution of a Nextflow script. You can also set these at runtime when launching a pipeline.

## Advanced options

<br>

{{% pretty_screenshot img="/uploads/2020/12/advanced_options.png" %}}

To match your cluster setup, these options allow you to customize the following default parameters:

**1.** the **storage mount path** which is by default `/scratch`

**2.** you can specify a default **work directory** where Nextflow will output results. Nextflow uses `$PWD/work` by default.  

**3.** You can edit the **Compute service account** field if the cluster has a specific **service account** setup to be used by Nextflow to execute jobs.
