---
title: Kubernetes
headline: 'Kubernetes Compute Environments'
description: 'Step-by-step instructions to set up a Nextflow Tower compute environment for a Kubernetes cluster'
---
## Overview

[Kubernetes](https://kubernetes.io/) is the leading technology for deployment and orchestration of containerized workloads in cloud-native environments.

Tower streamlines the deployment of Nextflow pipelines into Kubernetes both in the cloud and in on-premises solutions.

The following instructions are for a **generic Kubernetes** distribution. If you are using [Amazon EKS](../eks/) or [Google GKE](../gke/), see the corresponding documentation pages.


## Cluster preparation

This section describes the steps required to prepare your Kubernetes cluster for the deployment of Nextflow pipelines using Tower. It is assumed the cluster itself has already been created and you have administrative privileges.

**1. Verify connection.** Make sure you are able to connect to your Kubernetes cluster:
```bash
kubectl cluster-info
```

**2. Create namespace.** While not mandatory, it is generally recommended to create a separate namespace for your Tower deployment. You can name it whatever you like, but we will name it `tower-nf` in these instructions:
```bash
kubectl create ns tower-nf
```

Switch to the new namespace:
```bash
kubectl config set-context --current --namespace=tower-nf
```

**3. Create service account and role.** The service account and corresponding rolebinding is used by Tower to launch Nextflow pipelines and by Nextflow to submit pipeline tasks. Download [tower-launcher.yml](../_templates/tower-launcher.yml) :fontawesome-solid-file-download: into your environment:

<details>
    <summary>Click to view tower-launcher.yml</summary>
    ```yaml
    --8<-- "docs/_templates/tower-launcher.yml"
    ```
</details>

Then create the resources in your namespace:
```bash
kubectl apply -f tower-launcher.yaml
```

This creates a service account called `tower-launcher-sa`. Use this service account name when setting up the compute environment for this Kubernetes cluster in Tower.

**4. Configure persistent storage.** Tower requires a `ReadWriteMany` persistent volume claim (PVC) that is mounted by all nodes where workflow pods will be dispatched.

You can use any storage solution that supports the `ReadWriteMany` access mode (see [this page](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)). The setup of this storage is beyond the scope of these instructions, because the right solution for you will depend on what is available for your infrastructure or cloud vendor (NFS, GlusterFS, CephFS, Amazon FSx, etc). Ask your cluster administrator for more information.

Example PVC backed by local storage: [tower-scratch-local.yml](../_templates/tower-scratch-local.yml) :fontawesome-solid-file-download:

Example PVC backed by NFS server: [tower-scratch-nfs.yml](../_templates/tower-scratch-nfs.yml) :fontawesome-solid-file-download:


## Compute environment setup  


**1.** In a workspace choose "**Compute environments**" and then, click on the **New Environment** button.

**2.** Enter a name to identify it (e.g. *My K8s cluster*).

**3.** Select **Kubernetes** as the target platform.

![](_images/k8s_new_env.png)


**4.** Select an existing Kubernetes credentials or click the **+** button to create a new one.

**5.** Give a name to this new credentials record.

**6.** Enter the Kubernetes **Service account token** and then click **Create**.

![](_images/k8s_credentials.png)


!!! tip 
    The token can be found using the following command:

    ```bash
    SECRET=$(kubectl get secrets | grep <SERVICE-ACCOUNT-NAME> | cut -f1 -d ' ')
    kubectl describe secret $SECRET | grep -E '^token' | cut -f2 -d':' | tr -d '\t'
    ```

    Replace `<SERVICE-ACCOUNT-NAME>` with the name of the service account created in the [cluster preparation](#cluster-preparation) instructions. If you followed the example in those instructions, it should be `tower-launcher-sa`.


**7.** Enter Kubernetes **Master server** URL

!!! tip 
    The master server can be found using the following command: `kubectl cluster-info`

**8.** Enter the **SSL Certificate** to authenticate your connection.

!!! tip 
    The certificate data can be found in your `~/.kube/config` file, check for the `certificate-authority-data` field matching to the specified server URL.

**9.** Specify Kubernetes **Namespace** that should be used to deployment the pipeline execution.

If you followed the example from the [cluster preparation](#cluster-preparation) instructions, this field should be `tower-nf`.

**10.** Specify the Kubernetes **Head service account** that will be used to grant permissions to Tower to deploy the pods executions and related.

If you followed the example from the [cluster preparation](#cluster-preparation) instructions, this field should be `tower-launcher-sa`.

**11.** The **Storage claim** field allows you to specify the storage that Nextflow should use as a scratch file system for the pipeline execution.

This should reference a Kubernetes persistent volume claim with `ReadWriteMany` access mode. See the [cluster preparation](#cluster-preparation) instructions for details.

**12.** You can specify certain environment variables on the Head job or the Compute job using the **Environment variables** option.

![](_images/env_vars.png)


## Advanced options

These options allow the fine-tuning of the Tower configuration for the Kubernetes cluster.


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
