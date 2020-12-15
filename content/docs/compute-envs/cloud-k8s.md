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

headline: 'Kubernetes Compute environments'
description: 'Step-by-step instructions to set up a Kubernetes cluster using EKS and EGK and using them from Nextflow Tower.'
menu:
  docs:
    parent: Compute Environments
    weight: 6

---
## Overview

Kubernetes has quickly become the reference platform for deploying,
scaling, and managing of containerized enterprise applications and workloads.   

Tower allows the deployment of Nextflow pipelines in any Kubernetes distribution and has native support for Amazon EKS and Google GKE services.

The following guide will show you how to prepare your cluster depending on your infrastructure, and it will guide you through configuring Tower for you specific infrastructure

## Requirements

To allow Tower to operate with your Kubernetes cluster you will need:

**1.** The cluster server URL and certificate or the vendor specific credentials.

**2.** A Kubernetes namespace and service account that allows the execution of Nextflow pods.

**3.** A [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)
enabled shared file system used as scratch storage for pipeline execution.


## Cluster Prepartion

The following steps describe the operations required to prepare your Kubernetes cluster
in order to enable the deployment of Nextflow pipelines using Tower.

For the sake of this guide we assume a Kubernetes cluster has already been configured and
you have administration permissions.


### Verify connection

Make sure you are able to connect your Kubernetes cluster using the command:

{{% highlight bash %}}
kubectl cluster-info
{{% /highlight %}}

### Namespace creation

Even though this is not mandatory, it is generally recommendable to create a separate
Kubernetes namespace for your Tower deployment. Use the command below to create a new
Kubernetes namespace:

{{% highlight bash %}}
kubectl ns <YOUR-NAMESPACE>
{{% /highlight %}}

Replace the string `<YOUR-NAMESPACE>` with a name of your choice.
We'll use `tower-nf` for the sake of this guide.

Finally switch to the new workspace using the command below:

{{% highlight bash %}}
kubectl config set-context --current --namespace=<YOUR-NAMESPACE>
{{% /highlight %}}

e.g.

{{% highlight bash %}}
kubectl config set-context --current --namespace=tower-nf
{{% /highlight %}}

This will be your **Namespace** value in your Tower configuration.

{{% pretty_screenshot img="/uploads/2020/12/kubernetes_namespace.png" %}}


### Service account & role creation

This step creates a service account and the corresponding role to allow Tower to
operate properly.

Create the `k8s-config-rbac.yaml` required policy file by copy-pasting the following content in your
terminal:

{{% highlight bash "linenos=table,hl_lines=6 8 28-29"%}}
(
cat <<EOF
touch k8s-config-rbac.yaml
echo '''---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tower-launcher-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: tower-launcher-role
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/status", "pods/log", "jobs", "jobs/status", "jobs/log"]
    verbs: ["get", "list", "watch", "create", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: tower-launcher-rolebind
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: tower-launcher-role
subjects:
  - kind: ServiceAccount
    name: tower-launcher-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: tower-launcher-userbind
subjects:
  - kind: User
    name: tower-launcher-user
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: tower-launcher-role
  apiGroup: rbac.authorization.k8s.io
...''' > k8s-config-rbac.yaml
EOF
) | sh
{{% /highlight %}}

Then apply the policy to your cluster using this command:

{{% highlight bash %}}
kubectl apply -f k8s-config-rbac.yaml
{{% /highlight %}}

This creates the  **Head service account** named `tower-launcher-sa` (see highlighted lines) used in the Tower configuration. It is used by Tower to operate with the Kubernetes cluster and allow Nextflow to submit pipeline jobs.

{{% pretty_screenshot img="/uploads/2020/12/kubernetes_head_service_account.png" %}}

### Storage configuration

This step heavily depends on the storage options available in your infrastructure or
provided the by your cloud vendor.

Tower requires the use of a *ReadWriteMany* storage mounted in all computing
nodes where the pods will be dispatched.

Possible supported solution includes NFS server, GLusterFS, CephFS, Amazon FSx
amongst others. A comprehensive list of supported solutions is available [here](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes).

The setup of such storage is beyond the scope of this guide, ask your cluster administrator for more details.

The following steps show how to configure a persistent volume and access it through
a persistent volume claim for demoing purposes.

{{% warning "For testing purposes only "%}}
This only works for a single node cluster. **Do not use this in a production environment**.
{{% /warning %}}


{{% highlight bash "linenos=table,hl_lines=18-21" %}}
(
cat <<EOF
touch k8s-storage.yaml
echo '''---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: tower-storage
spec:
  storageClassName: scratch
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /tmp/tower
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: tower-scratch
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
  storageClassName: scratch
...''' > k8s-storage.yaml
EOF
) | sh
{{% /highlight %}}

Then apply it using the command:

{{% highlight bash %}}
kubectl apply -f k8s-storage.yaml
{{% /highlight %}}

The above operation creates a persistent volume of 10 GB and a **Storage
claim** named `tower-scratch` (see highlighted lines). This name will be used in the configuration
of Tower compute environment.

{{% pretty_screenshot img="/uploads/2020/12/kubernetes_storage_claim.png" %}}


### Amazon EKS specific setting

When operating with an Amazon EKS cluster you will need to assign
the service role created in the previous step with AWS user that will
be used by Tower to access to EKS cluster.

Use the following command to modify the EKS auth configuration:

{{% highlight bash %}}
kubectl edit configmap -n kube-system aws-auth
{{% /highlight %}}

Once the editor is opened add the following entry:

{{% highlight bash %}}
  mapUsers: |
    - userarn: <AWS USER ARN>
      username: tower-launcher-user
      groups:
        - tower-launcher-role
{{% /highlight %}}

Your user ARN can be found with the following command or using the [AWS IAM console](https://console.aws.amazon.com/iam):

{{% highlight bash %}}
aws sts get-caller-identity
{{% /highlight %}}         

{{% warning %}}
The same user need to be used when specifying the AWS credentials in the
configuration of the Tower compute environment for EKS.
{{% /warning %}}

For more details check the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

The AWS user should have the following IAM policy:

{{% highlight bash %}}
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TowerEks0",
      "Effect": "Allow",
      "Action": [
        "eks:ListClusters",
        "eks:DescribeCluster"
      ],
      "Resource": "*"
    }
  ]
}
{{% /highlight %}}

### Google GKE specific setting

If you are configuring a Google GKE cluster you will need to grant the cluster access to the service account
used to authenticate the Tower compute environment. This can be done updating the *role binding*
as shown below. Create a k8s_gke_role_binding.yaml file

{{% highlight bash %}}
(
cat <<EOF
touch k8s-gke-role-binding.yaml
echo '''---
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
...''' > k8s-gke-role-binding.yaml
EOF
) | sh
{{% /highlight %}}

In the above snippet replace the placeholder `<IAM SERVICE ACCOUNT>` with the corresponding service account e.g.
`test-account@test-project-123456.google.com.iam.gserviceaccount.com`.

update the *role binding* with the following command:

{{% highlight bash %}}
kubectl apply -f k8s-gke-role-binding.yaml
{{% /highlight %}}


For more details refers the [Google documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control).


## Tower configurations

Using the examples above, the remaining of this document will guide you through setting up a Kubernetes compute environment in Tower using a stand alone Kubernetes cluster, a Kubernetes EKS managed cluster, and a Kubernetes GKE managed cluster.

### Kubernetes standalone

 -----TO DO------

### Amazon EKS

The image bellow shows how to setup a compute environment for an EKS managed Kubernetes cluster. Note that although we use the values previously set, this guide assumes you have access to the **Cluster name**, the **Region** where the cluster is located, the **Storage mount path**, the **Work directory**, and the **Compute service account**.

{{% pretty_screenshot img="/uploads/2020/12/eks_env_setup.png" %}}

### Google GKE

-----TO DO------
