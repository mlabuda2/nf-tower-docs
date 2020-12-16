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

The following instruction are for a generic Kubernetes distribution. If you are using 
[Amazon EKS] or [Google GKE] see the corresponding documentation pages. 


## Compute environment setup  

**1.** In the navigation bar on the upper right, choose your account name then choose 
*Compute environments*. Click on the *New Environment* button.

**2.** Enter a name to identify it (e.g. *My K8s cluster*) and select **Kubernetes** as the target 
platform.

**3.** Select an existing Kubernetes credentials or click the **+** button to create a new one.

**4.** Give a name for the new credentials

**5.** Enter the Kubernetes cluster token and then click **Create**

{{% tip %}}
The token can be found using the following command: 

    kubectl describe secret $(kubectl get secrets | grep <SERVICE-ACCOUNT-NAME> | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t'

replacing `<SERVICE-ACCOUNT-NAME>` the name of the service account create in the *Cluster preparation* step
{{% /tip %}}


**6.** Enter Kubernetes *Master server* URL.

{{% tip %}}
The master server can be found using the following command:
    
       kubectl cluster-info
       
{{% /tip %}}

**7.** Enter the *SSL Certificate* to authenticate your connection. The certificate data 
can be found in the `~/.kube/config` file, check for the `certificate-authority-data` field
matching to the specified server URL.

**8.** Enter the *Namespace* create during the cluster preparation step e.g. `tower-nf`

**9.** Enter the *Head service account* name, which corresponds to the service account create 
in the *Cluster preparation* step, e.g. `tower-launcer-sa`. 

**10.** Enter the *Storage claim* name create in the *Cluster preparation* step. This 
should reference the shared file system that will be used a scratch storage for the Nextflow
execution (i.e. work directory).

