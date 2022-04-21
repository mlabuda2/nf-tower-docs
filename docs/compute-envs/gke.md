---
description: 'Step-by-step instructions to set up a Tower compute environment for Google GKE cluster'
---

## Overview

[Google GKE](https://cloud.google.com/kubernetes-engine) is a managed Kubernetes cluster that allows the execution of containerized workloads in Google Cloud at scale.

Tower offers native support for Google GKE clusters and streamlines the deployment of Nextflow pipelines in such environments.


## Requirements

You need to have a GKE cluster up and running. Make sure you have followed the [cluster preparation](../k8s/#cluster-preparation) instructions to create the cluster resources required by Tower. In addition to the generic Kubernetes instructions, you will need to make a few modifications specific to GKE.

**Assign service account role to IAM user.** You will need to grant the cluster access to the service account used to authenticate the Tower compute environment. This can be done by updating the *role binding* as shown below:

```yaml
cat << EOF | kubectl apply -f -
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: tower-launcher-userbind
subjects:
  - kind: User
    name: <IAM SERVICE ACCOUNT>
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: tower-launcher-role
  apiGroup: rbac.authorization.k8s.io
...
EOF
```

In the above snippet, replace `<IAM SERVICE ACCOUNT>` with the corresponding service account, e.g. `test-account@test-project-123456.google.com.iam.gserviceaccount.com`.

For more details, refer to the [Google documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control).


## Compute Environment

1. In a workspace, select **Compute Environments** and then **New Environment**.

2. Enter a descriptive name for this environment, e.g. "Google GKE (europe-west1)".

3. Select **Google GKE** as the target platform.

    ![](_images/gke_new_env.png)

4. Select your Google Cloud credentials or add new credentials by selecting the **+** button.

5. Select the **Location** of your GKE cluster.

    !!! warning "Regional and zonal clusters" 
        GKE clusters can be either *regional* or *zonal*. For example, `us-west1` identifies the United States West-Coast region, which has three zones: `us-west1-a`, `us-west1-b`, and `us-west1-c`.

        Tower self-completion only shows regions. You should manually edit this field if you are using a zonal GKE cluster.

    ![](_images/gke_regions.png)

6. Select or enter the **Cluster name** of your GKE cluster.

7. Specify the **Namespace** created in the [cluster preparation](#cluster-preparation) instructions, which is `tower-nf` by default.

8. Specify the **Head service account** created in the [cluster preparation](#cluster-preparation) instructions, which is `tower-launcher-sa` by default.

9. Specify the **Storage claim** created in the [cluster preparation](#cluster-preparation) instructions, which serves as a scratch filesystem for Nextflow pipelines. In each of the provided examples, the storage claim is called `tower-scratch`.

10. You can use the **Environment variables** option to specify custom environment variables for the Head job and/or Compute jobs.

    ![](_images/env_vars.png)

11. Configure any advanced options described below, as needed.

12. Select **Create** to finalize the compute environment setup.

    ![](_images/aws_new_env_manual_config.png) 

Jump to the documentation for [Launching Pipelines](../launch/launchpad.md).


### Advanced options

- The **Storage mount path** is the file system path where the Storage claim is mounted (default: `/scratch`).

- The **Work directory** is the file system path used as a working directory by Nextflow pipelines. It must be the the storage mount path (default) or a subdirectory of it.

- The **Compute service account** is the service account used by Nextflow to submit tasks (default: the `default` account in the given namespace).

- The **Pod cleanup policy** determines when terminated pods should be deleted.

- You can use **Custom head pod specs** to provide custom options for the Nextflow workflow pod (`nodeSelector`, `affinity`, etc). For example:
    ```yaml
    spec:
      nodeSelector:
        disktype: ssd
    ```

- You can use **Custom service pod specs** to provide custom options for the compute environment pod. See above for an example.

- You can use **Head Job CPUs** and **Head Job Memory** to specify the hardware resources allocated for the Nextflow workflow pod.
