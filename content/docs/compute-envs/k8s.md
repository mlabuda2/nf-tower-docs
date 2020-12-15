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

The following guide will show you examples to help you prepare your cluster on various infrastructures.

## Requirements

To allow Tower to operate with your Kubernetes cluster you will need:

**1.** Make sure you have kubectl installed and configured for your cluster.

**2.** The cluster server URL and certificate or the vendor specific credentials.

**3.** A Kubernetes namespace and service account that allows the execution of Nextflow pods.

**4.** A [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)
enabled shared file system used as scratch storage for pipeline execution.


## Cluster Prepartion

The following steps describe the operations required to prepare your Kubernetes cluster
in order to enable the deployment of Nextflow pipelines using Tower.

For the sake of this guide we assume a Kubernetes cluster has already been configured and
you have administration permissions.


### Verify connection

Make sure you are able to connect your Kubernetes cluster using the command:

```
kubectl cluster-info
```

### Namespace creation

Even though this is not mandatory, it is generally recommendable to create a separate
Kubernetes namespace for your Tower deployment. Use the command below to create a new
Kubernetes namespace:

```
kubectl create namespace <YOUR-NAMESPACE>
```

Replace the string `<YOUR-NAMESPACE>` with a name of your choice.
We'll use `tower-nf` for the sake of this guide.

Finally switch to the new workspace using the command below:

```
kubectl config set-context --current --namespace=<YOUR-NAMESPACE>
```

e.g.

```
kubectl config set-context --current --namespace=tower-nf
```

This will be your **Namespace** value in your Tower configuration.

{{% pretty_screenshot img="/uploads/2020/12/kubernetes_namespace.png" %}}


### Service account & role creation

This step creates a service account and the corresponding role to allow Tower to
operate properly.

Create the `k8s-config-rbac.yaml` required policy file by copy-pasting the following content in your
terminal:

{{% highlight bash "linenos=table,hl_lines=6-8 11-13 28-29"%}}
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

```
kubectl apply -f k8s-config-rbac.yaml
```

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

You can use the following kubernetes configuration to test **one node clusters** in  **Do not use this in a production environment**. Note that Google GKE clusters have a minimum size of three nodes, an example configuration for testing GKE clusters is provided in the GKE section bellow.  

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

```
kubectl apply -f k8s-storage.yaml
```

The above operation creates a persistent volume of 10 GB and a **Storage claim** named `tower-scratch` (see highlighted lines). This name will be used in the configuration of Tower compute environment.

{{% pretty_screenshot img="/uploads/2020/12/kubernetes_storage_claim.png" %}}


### Amazon EKS specific setting

When operating with an Amazon EKS cluster you will need to assign the service role created in the previous step with AWS user that will be used by Tower to access to EKS cluster.

Use the following command to modify the EKS auth configuration:

```
kubectl edit configmap -n kube-system aws-auth
```

Once the editor is opened add the following entry:

```
  mapUsers: |
    - userarn: <AWS USER ARN>
      username: tower-launcher-user
      groups:
        - tower-launcher-role
```

Your user ARN can be found with the following command or using the [AWS IAM console](https://console.aws.amazon.com/iam):

```
aws sts get-caller-identity
```

{{% warning %}}
The same user need to be used when specifying the AWS credentials in the configuration of the Tower compute environment for EKS.
{{% /warning %}}

For more details check the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

The AWS user should have the following IAM policy:

```
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
```

### Google GKE specific setting

If you are configuring a Google GKE cluster you will need to grant the cluster access to the **service account**
used to authenticate the Tower compute environment. This can be done updating the *role binding*
as shown below. Create a k8s_gke_role_binding.yaml file

```
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
```

In the above snippet replace the placeholder `<IAM SERVICE ACCOUNT>` with the corresponding service account e.g.
`test-account-role-dev@test-project-123456.google.com.iam.gserviceaccount.com`.

{{% note %}}
The IAM service account needs to be created by an administrator of the Google account. Save the **JSON credentials** for later use during the Tower configuration.
{{% /note %}}

update the *role binding* with the following command:

```
kubectl apply -f k8s-gke-role-binding.yaml
```

For more details refers the [Google documentations](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control).

### GKE Storage configuration

In this example, we will use a *ReadWriteMany* storage system that and mount it with write permission with a NFS server.

Generate a yaml file for the NFS service with this command:

{{% highlight bash "linenos=table,hl_lines=7 58" %}}
(
cat <<EOF
touch gke-nfs-server.yaml
echo '''kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nfs-server
  namespace: tower-nf
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-server
  namespace: tower-nf
spec:
  replicas: 1
  selector:
    matchLabels:
      role: nfs-server
  template:
    metadata:
      labels:
        role: nfs-server
    spec:
      containers:
      - name: nfs-server
        image: gcr.io/google_containers/volume-nfs:0.8
        ports:
          - name: nfs
            containerPort: 2049
          - name: mountd
            containerPort: 20048
          - name: rpcbind
            containerPort: 111
        securityContext:
          privileged: true
        volumeMounts:
          - mountPath: /exports
            name: vol-1
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: nfs-server
---

apiVersion: v1
kind: Service
metadata:
  name: nfs-server
  namespace: tower-nf
spec:
  ports:
    - name: nfs
      port: 2049
    - name: mountd
      port: 20048
    - name: rpcbind
      port: 111
  selector:
    role: nfs-server
''' > gke-nfs-server.yaml
EOF
) | sh
{{% /highlight %}}

{{% note %}}
Note we are using the **namespace** nf-tower set above.
{{% /note %}}

Create the nfs-server service with the following command:

```
kubectl apply -f gke-nfs-server.yaml
```

Now we need to create the volume and volume claim (you may need to change the **server domain name** if you've chosen a different **namespace** or **service name** in the previous steps):

{{% highlight bash "linenos=table,hl_lines=23-24" %}}
(
cat <<EOF
touch gke-volume.yaml
echo '''
apiVersion: v1
kind: PersistentVolume
metadata:
  name: tower-storage
  namespace: tower-nf
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: nfs-server.tower-nf.svc.cluster.local
    path: "/"

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: tower-scratch
  namespace: tower-nf
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 1Gi
''' > gke-volume.yaml
      EOF
      ) | sh
{{% /highlight %}}

Note the name of the **persistent volume claim** `tower-scratch` will be used for Tower configuration.

Create the persistent volume and the persistent volume claim with ReadWriteMany with the command:

```
kubectl apply -f gke-volume.yaml
```


## Tower configurations

Using the examples above, the remaining of this document will guide you through setting up a Kubernetes compute environment in Tower using a Kubernetes EKS managed cluster, and a Kubernetes GKE managed cluster.


### Amazon EKS

#### Requirements:

This guide assumes a Kubernetes cluster has been configured with EKS and that you have access to the **Kubernetes cluster name**, the **Region** where the cluster is located, and your **AWS keys**.


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


### Google GKE

#### Requirements:

This guide assumes a Kubernetes cluster has been configured with EKS and that you have access to the **Kubernetes cluster name**, the **Location or sub-region** where the cluster is located, and your google **JSON credentials**.


**1.** In the navigation bar on the upper right, choose your account name then choose **Compute environments** and select **New Environment**.

{{% pretty_screenshot img="/uploads/2020/09/aws_new_env.png" %}}

</br>

**2.** Enter a descriptive name for this environment. For example, *Goole GKE* and select **Google GKE** as the target platform.

{{% pretty_screenshot img="/uploads/2020/12/gke_new_env.png" %}}

**3.** Select your Google Cloud credentials.

**4.** Enter the region where the Kubernetes cluster is located.

{{% warning "Zonal and regional clusters" %}}
In google clusters can be regional or zonal, For example, the us-west1 region the west coast of the United States has three zones: us-west1-a, us-west1-b, and us-west1-c.

Tower self-completion only shows regions. You can manually edit this field if your cluster is in a zone.

{{% /warning %}}

{{% pretty_screenshot img="/uploads/2020/12/gke_regions.png" %}}

Google regions

{{% pretty_screenshot img="/uploads/2020/12/gke_zone.png" %}}

Manually edited Google zone

**5** Enter the **namespace** e.g `tower-nf` like the [examples](#namespace-creation) above.

**6** Enter the **head service account** e.g `tower-launcher-sa` as was set as the [role and service account examples](#service-account-role-creation) above.

**7** Enter the **storage claim** e.g `tower-scratch` as was set in the [storage configuration](#gke-storage-configuration).

{{% pretty_screenshot img="/uploads/2020/12/gke_env_setup.png" %}}
