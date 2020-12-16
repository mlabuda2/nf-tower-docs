---
title: Kubernetes
weight: 1
layout: single
publishdate: 2020-10-20 04:00:00 +0000
authors:
  - "Jordi Deu-Pons"
  - "Paolo Di Tommaso"
  - "Alain Coletta"
  - "Seqera Labs"

headline: 'Kubernetes Compute environment'
description: 'Step-by-step instructions to set up a Nextflow Tower compute environment for a Kubernetes cluster'
menu:
  docs:
    parent: Compute Environments
    weight: 6

---
## Overview

Kubernetes is the leading technology for the deployment and the orchestration of
of containerised workload in cloud-native environments.

Tower streamlines the deployment of Nextflow pipelines into Kubernetes either on
cloud and on-premises

The following guide will show you examples to help you prepare your cluster on various infrastructures.


## Requirement

You need to have Kubernetes cluster up and running. Make sure you have followed
the steps in the [Cluster preparation] guide to create the cluster resources required
by Tower.

The following instruction are for a **generic Kubernetes** distribution. If you are using
[Amazon EKS](/docs/compute-envs/eks/) or [Google GKE](/docs/compute-envs/gke/) see the corresponding documentation pages.


## Compute environment setup  

**1.** In the navigation bar on the upper right, choose your account name then choose
*Compute environments*. Click on the *New Environment* button.

{{% pretty_screenshot img="/uploads/2020/09/aws_new_env.png" %}}


**2.** Enter a name to identify it (e.g. *My K8s cluster*) and select **Kubernetes** as the target
platform.

{{% pretty_screenshot img="/uploads/2020/12/k8s_new_env.png" %}}


**3.** Select an existing Kubernetes credentials or click the **+** button to create a new one.

**4.** Give a name for the new credentials

**5.** Enter the Kubernetes cluster token and then click **Create**

{{% tip "Kubernetes token"%}}
The token can be found using the following command:

```
    kubectl describe secret $(kubectl get secrets | grep <SERVICE-ACCOUNT-NAME> | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t'
```

replacing `<SERVICE-ACCOUNT-NAME>` the name of the service account create in the *Cluster preparation* step
{{% /tip %}}

{{% pretty_screenshot img="/uploads/2020/12/k8s_credentials.png" %}}


**6.** Enter Kubernetes *Master server* URL.

{{% tip "Kubernetes master server" %}}
The master server can be found using the following command:

```
       kubectl cluster-info
```

{{% /tip %}}

**7.** Enter the *SSL Certificate* to authenticate your connection. The certificate data
can be found in your `~/.kube/config` file, check for the `certificate-authority-data` field
matching to the specified server URL.

**8.** Enter the *Namespace* create during the cluster preparation step e.g. `tower-nf`

**9.** Enter the *Head service account* name, which corresponds to the service account create
in the *Cluster preparation* step, e.g. `tower-launcer-sa`.

**10.** Enter the *Storage claim* name create in the *Cluster preparation* step (`tower-scratch`). This
should reference the shared file system that will be used a scratch storage for the Nextflow
execution (i.e. work directory).

{{% pretty_screenshot img="/uploads/2020/12/k8s_new_env_setup.png" %}}

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
