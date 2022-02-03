---
title: AWS Batch
headline: 'AWS Batch Compute Environment'
description: 'Step-by-step instructions to set up AWS Batch in Nextflow Tower.'

---
## Overview
!!! note "Disclaimer"
    This guide assumes you have an existing [Amazon Web Service (AWS) Account](https://aws.amazon.com/). Sign up for a free AWS account [here](https://portal.aws.amazon.com/billing/signup).

There are two ways to create a **Compute Environment** for **AWS Batch** with Tower.

1. **Tower Forge** for AWS Batch: This option automatically manages the AWS Batch resources in your AWS account.

2. **Tower Launch**: It allows you to create a compute environment using existing AWS Batch resources.

If you don't have an AWS Batch environment fully set-up yet, it is suggested to follow the [Tower Forge](#forge) guide. 

If your administrator has provided you with an AWS queue, or if you have set up AWS Batch previously, please follow the [Tower Launch](#manual-enabling) guide.

## Forge

!!! warning
    Follow these instructions if you have **not** pre-configured an AWS Batch environment. Note that this will create resources in your AWS account that you may be charged for by AWS.

Tower Forge automates the configuration of an [AWS Batch](https://aws.amazon.com/batch/) compute environment and queues required for the deployment of Nextflow pipelines.

## Forge AWS Resources

### IAM User Permissions

To use the Tower Forge feature, Tower requires an Identity and Access Management (IAM) user with the permissions listed in the following [policy file](https://github.com/seqeralabs/nf-tower-aws/blob/master/forge/forge-policy.json). These authorizations are more permissive than those required to only launch a pipeline, since Tower needs to manage AWS resources on your behalf.

The steps below will guide you through the creation of a new IAM user for Tower, plus how to attach the required policy for the newly created user.

**1.** Open the [AWS IAM console](https://console.aws.amazon.com/iam).
**2** Select **Users** on the left menu and click the **Add User** button on top.

![](_images/aws_aim_new_user.png)


**3.** Enter a name for your user (e.g. `tower`) and choose the **Programmatic access** type. 

**4** Select the **Next: Permissions** button.

**5.** Click on the **Next: Tags** button, then **Next: Review** and **Create User**.

![](_images/aws_user_no_permissions.png)


!!! warning  "This user has no permissions"
     For the time being, you can ignore the warning. It will be addressed through our team using an **IAM Policy** later on.


**6.** Save the **Access key ID** and **Secret access key** in a secure location as we will be using these in the next section. 

**7** Once you have saved the keys, press the **Close** button.

![](_images/aws_user_created.png)


**8.** Back in the users table, select the newly created user and click **+ Add inline policy** to add user permissions.

![](_images/aws_add_inline_policy.png)


**9.** Copy the content of the [policy linked above](https://github.com/seqeralabs/nf-tower-aws/blob/master/forge/forge-policy.json) into the "JSON" tab as seen underneath.

![](_images/aws_review_policy.png)


**10.** Select the **Review policy** button, then name your policy (e.g. `tower-forge-policy`), and confirm the operation by clicking on the **Create policy** button.

!!! tip "What permissions are required?"
    This policy includes the minimal permissions required to allow the user to submit jobs to AWS Batch, gather the container execution metadata, read CloudWatch logs and access data from the S3 bucket in your AWS account in read-only mode.


### Creating an S3 Bucket for Storage

S3 stands for Simple Storage Service and is a type of **object storage**. To access files and store the results for our pipelines, we have to create an **S3 Bucket** next.

We must grant our new Tower IAM user access to this bucket.

**1.** Navigate to [S3 service](https://console.aws.amazon.com/s3/home) 

**2.** Select **Create New Bucket**.

**3.** Enter a unique name for your Bucket and select a region.

![](_images/aws_create_bucket.png)


!!! warning "Which AWS region should I use?"
    The region of the bucket should be in the *same region as the compute environment which we will set in the next section*. Typically users select a region closest to their physical location but Tower Forge supports creating resources in any of the available AWS regions.


**4.** Select the default options for **Configure options**.

![](_images/aws_new_bucket_configure_options.png)


**5.** Select the default options for **Set permissions**.

![](_images/aws_new_bucket_set_permissions.png)


**6.** Review the bucket and select **Create bucket**.

![](_images/aws_new_bucket_review.png)


!!! warning  "S3 Storage Costs" 
    S3 is used by Nextflow for the storage of intermediary files. For production pipelines, this can amount to a large quantity of data. To reduce costs, when configuring a bucket, users should consider management options such as the ability to automatically delete these files after 30 days. For more information on this process, click [here] (https://aws.amazon.com/premiumsupport/knowledge-center/s3-empty-bucket-lifecycle-rule/).


## Forge compute environment

!!! note "Awesome!"
    You have completed the AWS environment setup for Tower.


Now we can add a new **AWS Batch** environment in the Tower User Interface (UI). To create a new compute environment, follow these steps:


**1.** In a workspace choose "Compute environments" and then, click on the **New Environment** button.


**2.** Enter a descriptive name for this environment. 

For example, *AWS Batch Spot (eu-west-1)* and select **Amazon Batch** as the target platform.

![](_images/aws_new_env_name.png)


**3.** Add new credentials by selecting the **+** button. 

**4.** Choose a name, e.g. *AWS Credentials*.

**5.** Add the Access key and Secret key. 

These are the keys we saved in the previous steps when creating the AWS IAM user.

![](_images/aws_keys.png)


!!! tip "Multiple credentials"
    You can create multiple credentials in your Tower environment.


**6.** Select a **Region**, for example *eu-west-1 - Europe (Ireland)*, and enter the S3 bucket we created in the previous section in the **Pipeline work directory** e.g: `s3://unique-tower-bucket`.

**7.** Select **Batch Forge** as the **Config Mode**.

!!! warning
    The bucket should be in the same **Region** as selected above.
    
    
![](_images/aws_s3_bucket_region.png)


**8.** Choose a **Provisioning model**. 

In most cases this will be *Spot*.

!!! tip "Spot or On-demand?"
    You can choose to create a compute environment that will launch either **Spot** or **On-demand** instances. **Spot instances can cost as little as 20% of on-demand instances** and with Nextflow's ability to automatically relaunch failed tasks, Spot is almost always the recommended provisioning model.
    Note, however, that when choosing *Spot* instances, Tower will also create a dedicated queue for running the main Nextflow job using a single on-demand instance in order to prevent any execution interruptions.

![](_images/aws_cpus.png)

**9.** Enter the **Max CPUs** e.g. `64`. 

This is the maximum number of combined CPUs (the sum of all instances CPUs) AWS Batch will launch at any time.

**10.** Choose **EBS Auto scale** to allow the EC2 virtual machines to expand the amount of available disk space during task execution.

**11.** With the optional **Enable Fusion mounts** feature enabled, S3 buckets specified in the **Pipeline work directory** and **Allowed S3 Buckets** fields will be mounted as file system volumes in the EC2 instances carrying out the Batch job execution. These are then accessible at the path location with the pattern `/fusion/s3/BUCKET_NAME`.


For example if the bucket name is `s3://imputation-gp2`, the Nextflow pipeline will access it using the file system path `/fusion/s3/imputation-gp2`.

!!! tip
    Note that it is not required to modify your pipeline or files to take advantage of this feature. Nextflow is able to recognise these buckets automatically and will replace any reference to s3:// prefixed files with the corresponding Fusion mount paths.


**12.** Choose **Enable GPUs** to allow the deployment of GPU enabled EC2 virtual machines if required.

**13.** Enter any additional **Allowed S3 buckets** that your workflows require to read input data or to write output files. 

The **Pipeline work directory** bucket above is added by default to the list of **Allowed S3 buckets**.


**14.** To use **EFS**, you can either specify the existing EFS option using **Use existing EFS file system** or deploy a new EFS using **Create new EFS file system** option.


**15.** To use **FSx**, you can enter `/fsx` as the **FSx mount path** and set the **Pipeline work directory** above to be `/fsx/work`

![](_images/aws_lustre_options.png)


**16.** Choose the **Dispose resources** option.


**17.** You can specify custom environment variables on the Head job or the Compute job using the **Environment variables** option.

![](_images/env_vars.png)

**Advanced options**

**18.** Optionally, you can specify the **Allocation strategy** and indicate the preferred **Instance types** to AWS Batch.

**19.** You can configure your custom networking setup using the `VPC`, `Subnets` and `Security groups` fields. 

!!! warning "AMI ID - AMI requirements for AWS Batch use"
    To use an existing AMI, make sure the AMI is based on an Amazon Linux-2 ECS optimized image that meets the Batch requirements. To learn more about approved versions of the Amazon ECS optimized AMI, visit [this link](https://docs.aws.amazon.com/batch/latest/userguide/compute_resource_AMIs.html#batch-ami-spec)

!!! tip "Remote access"
    If you need to debug the EC2 instance provisioned by AWS Batch, specify the `Key pair` to login the VM via SSH.

**20.** Optionally, you can set **Min CPUs** to be greater than `0`, EC2 instances will remain active. An advantage of this is that a pipeline execution will initialize faster.

!!! warning "Min CPUs - Editing this will result in additional AWS costs" 
    Keeping EC2 instances running may result in additional costs. You will be billed for these running EC2 instances regardless of whether you are executing pipelines or not.

![](_images/aws_warning_min_cpus.png)

**21.** You can specify the hardware resources allocated for the Head Job using **Head Job CPUs** and **Head Job Memory**

**22.** For fine-grained IAM permissions for the Head Job and Compute Job, you can rely upon **Head Job role** and **Compute Job role** 

**23.** If you're using the `Spot instances`, then you could also specify the `Cost percentage` to determine the maximum percentage that a `Spot instance` price can be, when compared with the `On-Demand` price for that instance type, before instances are launched.

![](_images/aws_cost_percentage.png) 

**23.** Optionally, you can also specify the location of `aws` cli using the **AWS CLI tool path**.

**24.** Select **Create** to finalize the compute environment setup. 

It will take a few seconds for all the resources to be created and then you will be ready to launch pipelines.

![](_images/aws_60s_new_env.png) 


Jump to the documentation section for [Launching Pipelines](../launch/launchpad.md).

## Manual Enabling

This section is for users with a pre-configured AWS environment. You will need a Batch queue, Batch compute environment, an IAM user and an S3 bucket already set up.

To enable Tower within your existing AWS configuration, you need to have an IAM user with the following IAM permissions:

- `AmazonS3ReadOnlyAccess`
- `AmazonEC2ContainerRegistryReadOnly`
- `CloudWatchLogsReadOnlyAccess`
- A [custom policy](https://github.com/seqeralabs/nf-tower-aws/blob/master/launch/launch-policy.json) to grant the ability to submit and control Batch jobs.
- Write access to any S3 bucket used pipeline work directories with the following [policy template](https://github.com/seqeralabs/nf-tower-aws/blob/master/launch/s3-bucket-write.json). See [below for details](#access-to-s3-buckets)

With these permissions set, we can add a new **AWS Batch** environment in the [Tower UI](#launch-compute-environment)

## Manual compute environment
To create a new compute environment for AWS Batch (Manual):

**1.** In a workspace choose "Compute environments" and then, click on the **New Environment** button.


**2.** Choose a descriptive name for this environment. 

For example "AWS Batch Launch (eu-west-1)".

**3.** Select **Amazon Batch** as the target platform.

![](_images/aws_new_launch_env.png) 


**4.** Add new credentials by clicking the "+" button. 

**5.** Choose a name, add the **Access key** and **Secret key** from your IAM user.

![](_images/aws_keys.png) 

!!! tip "Multiple credentials"
    You can create multiple credentials in your Tower environment. See the section **Credentials Management**.


**6.** Select a region, for example "eu-west-1 - Europe (Ireland)"

**7.** Enter an S3 bucket path, for example "s3://tower-bucket"

**8.** the **Manual** config mode.

**9.** Enter the **Head queue**, which is the name of the AWS Batch queue that the Nextflow driver job will run. 

**10.** Enter the **Compute queue**, which is the name of the AWS Batch queue that tasks will be submitted to.

**11.** Select **Create** to finalize the compute environment setup.

![](_images/aws_new_env_manual_config.png) 



**12.** You can specify certain environment variables on the Head job or the Compute job using the **Environment variables** option.

![](_images/env_vars.png)



**Advanced options**

**13.** You can specify the hardware resources allocated for the Head Job using **Head Job CPUs** and **Head Job Memory**

**14.** For fine-grained IAM permissions for the Head Job and Compute Job, you can rely upon **Head Job role** and **Compute Job role** 

**15.** Optionally, you can also specify the location of `aws` cli using the **AWS CLI tool path**.

**16.** Select **Create** to finalize the compute environment setup. 


### Access to S3 Buckets

Tower can use S3 to access data, create work directories and write outputs. The IAM user above needs permissions to use these S3 Buckets. We can set a policy for our IAM user that provides the permission to access specific buckets.

**1.** Access the IAM User table in the [IAM service](https://console.aws.amazon.com/iam/home)

**2.** Select the IAM user.

**3.** Select **+ add inline policy**.

![](_images/aws_user_s3_inline_policy.png) 


**4.** Select JSON and copy the contents of [this policy](https://github.com/seqeralabs/nf-tower-aws/blob/master/launch/s3-bucket-write.json). Replace lines 10 and 21 with your bucket name.

![](_images/aws_s3_policy.png) 


**5.** Name your policy and click **Create policy**.


Jump to the documentation section for [Launching Pipelines](../launch/launchpad.md).
