## Overview 

Kubernetes quickly become the reference platform for deploying, 
scaling, and managing of containerized enterprise applications and workloads.   

Tower allows the deployment of Nextflow pipelines in any Kubernetes distribution. 

## Requirements 

To allow Tower to operate with your Kubernetes cluster you will need: 

1. The cluster server URL and certificate or the vendor specific credentials 
2. A Kubernetes namespace and service account that allows the execution of Nextflow pods   
3. A [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) 
enabled shared file system used as scratch storage for pipeline execution.   

## Cluster preparation 

The following steps describe the operations required to prepare your Kubernetes cluster 
in order to enable to deployment of Nextflow pipelines using Tower. 

For the sake of this guide we assume the Kubernetes cluster is already configured and 
you administration permissions. 


### 0. Verify connection 

Make sure you are able to connect your Kubernetes cluster using the command: 

```
kubectl cluster-info
``` 

### 1. Namespace creation

Even though this is not mandatory, it is generally recommendable to create a separate 
Kubernetes namespace for your Tower deployment. Use the command below to create a new 
Kubernetes namespace:

```
kubectl ns <YOUR-NAMESPACE> 
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

### 2. Service account & role creation 

This step creates a service account and the corresponding role to allow Tower to 
operate properly. 

Create the required policy file copy & pasting the following content in your 
terminal: 
 
```
cat > k8s-config-rbac.yaml << EOF

EOF
```

Then apply the policy to your cluster using this command: 

``` 
kubectl apply -f k8s-config-rbac.yaml
```

This creates a service account named `tower-launcher-sa` that will used by 
Tower to operate with the Kubernetes cluster and allow Nextflow to submit 
the pipeline jobs.

The service account name will be used to in the configuration of the 
Tower compute environment.  

### 3. Storage configuration 

This step heavily depends on the storage options available in your infra or 
provided the by the cloud vendor. 

Tower requires the use of a *ReadWriteMany* storage mounted in all computing 
nodes where the pods will be dispatched.  

Possible supported solution includes NFS server, GLusterFS, CephFS, Amazon FSx
between the others. A comprehensive list is available at 
[this link](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes).    

The setup of such storage is beyond the scope of this guide. 
Ask your cluster administrator for more details.  

This guides shows how to configure a persistent volume and access it through
a persistent volume claim for demoing purpose. 

{{% warning %}}
This only works for a single node cluster. DO NOT USE IT IN A PRODUCTION ENVIRONMENT. 
{{% /warning %}}


```
cat > k8s-storage.yaml << EOF
---
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
...
EOF
```

Then apply it using the command: 

```
kubectl apply -f k8s-storage.yaml
```                              

The above operation creates a persistent volume of 10 GB and a volume 
claim named `tower-scratch`. This name will be used in the configuration 
of Tower compute environment. 

### 4. Amazon EKS specific setting 

When operating with a Amazon EKS cluster you will need to assign 
the service role created in the previous step with AWS user that will 
be used by Tower to access to EKS cluster. 

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

Your user ARN can be found with the following command or using the 
 [AWS IAM console](https://console.aws.amazon.com/iam): 

```
aws sts get-caller-identity
```                        
 
{{% warning %}}
The same user need to be used when specifying the AWS credentials in the 
configuration of the Tower compute environment for EKS. 
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

### 5. Google GKE specific setting 

When config a Google GKE cluster you will need to grant the cluster access to the service account 
used to authenticate the Tower compute environment. This can be done updating the *role binding* 
as shown below:

```
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
In the above snippet replace the placeholder `<IAM SERVICE ACCOUNT>` with the corresponding service account e.g.
`test-account@test-project-123456.google.com.iam.gserviceaccount.com`.

For more details refers the [Google documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control).
