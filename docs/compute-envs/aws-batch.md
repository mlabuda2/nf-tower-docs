---
---

## Overview

!!! note "Requirements"

There are two ways to create a **Compute Environment** for **AWS Batch** with Tower:

1. **Tower Forge**: This option automatically manages the AWS Batch resources in your AWS account.

2. **Manual**: This option allows you to create a compute environment using existing AWS Batch resources.

If you don't have an AWS Batch environment fully set-up yet, it is suggested to follow the [Tower Forge](#tower-forge) guide.

If you have been provided an AWS Batch queue from your account administrator, or if you have set up AWS Batch previously, please follow the [Manual](#manual) guide.

## Tower Forge

!!! warning

Tower Forge automates the configuration of an [AWS Batch](https://aws.amazon.com/batch/) compute environment and the queues required for deploying Nextflow pipelines.

### IAM

To use the Tower Forge feature, Tower requires an Identity and Access Management (IAM) user with the permissions listed in the following [policy file](../_templates/aws-batch/forge-policy.json). These authorizations are more permissive than those required to only [launch](../_templates/aws-batch/launch-policy.json) a pipeline, since Tower needs to manage AWS resources on your behalf.


#### Create Tower IAM policies

1. Open the [AWS IAM console](https://console.aws.amazon.com/iam).


3. Select **Create policy**.

4. On the **Create policy** page, select the **JSON** tab.



7. Select **Next: Review**.



#### Create an IAM user

1. From the [AWS IAM console](https://console.aws.amazon.com/iam), select **Users** in the left navigation menu, then select **Add User** at the top rigt of the page.

2. Enter a name for your user (e.g. `tower`) and select the **Programmatic access** type.

3. Select **Next: Permissions**.

4. Select **Next: Tags**, then **Next: Review** and **Create User**.


5. Save the **Access key ID** and **Secret access key** in a secure location as we will use these in the next section.

6. Once you have saved the keys, select **Close**.



9. Select **Next: Review**.

10. Select **Add permissions**.

### S3 Bucket

S3 stands for "Simple Storage Service" and is a type of **object storage**. To access files and store the results for our pipelines, we have to create an **S3 Bucket** and grant our new Tower IAM user access to it.

1. Navigate to [S3 service](https://console.aws.amazon.com/s3/home).

2. Select **Create New Bucket**.

3. Enter a unique name for your Bucket and select a region.


4. Select the default options for **Configure options**.

5. Select the default options for **Set permissions**.

6. Review and select **Create bucket**.


### Compute Environment

Tower Forge automates the configuration of an [AWS Batch](https://aws.amazon.com/batch/) compute environment and queues required for the deployment of Nextflow pipelines.

Once the AWS resources are set up, we can add a new **AWS Batch** environment in Tower. To create a new compute environment:




    ![](_images/aws_new_env_name.png)




    ![](_images/aws_keys.png)

    !!! tip "Multiple credentials"

    !!! note "Container registry credentials"



    !!! warning



11. Select **Enable fast instance storage** to allow the use of NVMe instance storage to speed up I/O and disk access operations. NVMe instance storage requires Fusion v2 to be enabled (see above).  

    !!! note
    Fast instance storage requires an EC2 instance type that uses NVMe disks. Tower validates any instance types you specify (from **Advanced options > Instance types**) during compute environment creation. If you do not specify an instance type, a standard EC2 instance with NVMe disks will be used (`'c5ad', 'c5d', 'c6id', 'i3', 'i4i', 'm5ad', 'm5d', 'm6id', 'r5ad', 'r5d', 'r6id'` EC2 instance families) for fast storage. 


12. Set the **Config mode** to **Batch Forge**.

13. Select a **Provisioning model**. In most cases this will be **Spot**.

    !!! tip "Spot or On-demand?"

        Note, however, that when choosing Spot instances, Tower will also create a dedicated queue for running the main Nextflow job using a single on-demand instance in order to prevent any execution interruptions.

14. Enter the **Max CPUs** e.g. `64`. This is the maximum number of combined CPUs (the sum of all instances CPUs) AWS Batch will provision at any time.

15. Select **EBS Auto scale** to allow the EC2 virtual machines to dynamically expand the amount of available disk space during task execution.

    !!! warning "EBS autoscaling may cause unattached volumes on large clusters"

16. With the optional **Enable Fusion mounts** feature enabled, S3 buckets specified in **Pipeline work directory** and **Allowed S3 Buckets** will be mounted as file system volumes in the EC2 instances carrying out the Batch job execution. These buckets will be accessible at `/fusion/s3/<bucket-name>`. For example, if the bucket name is `s3://imputation-gp2`, the Nextflow pipeline will access it using the file system path `/fusion/s3/imputation-gp2`.

    !!! tip


18. Enter any additional **Allowed S3 buckets** that your workflows require to read input data or write output data. The **Pipeline work directory** bucket above is added by default to the list of **Allowed S3 buckets**.

19. To use **EFS**, you can either select **Use existing EFS file system** and specify an existing EFS instance, or select **Create new EFS file system** to create one. If you intend to use the EFS file system as your work directory, you will need to specify `<your_EFS_mount_path>/work` in the **Pipeline work directory** field (step 8 of this guide).

    - To use an existing EFS file system, enter the **EFS file system id** and **EFS mount path**. This is the path where the EFS volume is accessible to the compute environment. For simplicity, we advise that you use `/mnt/efs` as the EFS mount path.
    - To create a new EFS file system, enter the **EFS mount path**. We advise that you specify `/mnt/efs` as the EFS mount path.


- To use an existing FSx file system, enter the **FSx DNS name** and **FSx mount path**. The FSx mount path is the path where the FSx volume is accessible to the compute environment. For simplicity, we advise that you use `/mnt/fsx` as the FSx mount path.
- To create a new FSx file system, enter the **FSx size** (in GB) and the **FSx mount path**. We advise that you specify `/mnt/fsx` as the FSx mount path.

21. Select **Dispose resources** if you want Tower to automatically delete these AWS resources if you delete the compute environment in Tower.

22. You can use the **Environment variables** option to specify custom environment variables for the Head job and/or Compute jobs.

23. Configure any advanced options described below, as needed.

24. Select **Create** to finalize the compute environment setup. It will take a few seconds for all the resources to be created, and then you will be ready to launch pipelines.

    ![](_images/aws_new_env.png)

Jump to the documentation for [Launching Pipelines](../launch/launchpad.md).

#### Advanced options

- You can specify the **Allocation strategy** and indicate the preferred **Instance types** to AWS Batch.

- You can configure your custom networking setup using the **VPC ID**, **Subnets** and **Security groups** fields.

- You can specify a custom **AMI ID**.



- If you need to debug the EC2 instance provisioned by AWS Batch, specify a **Key pair** to login to the instance via SSH.

- You can set **Min CPUs** to be greater than `0`, in which case some EC2 instances will remain active. An advantage of this is that pipeline executions will initialize faster.


- You can use **Head Job CPUs** and **Head Job Memory** to specify the hardware resources allocated for the Head Job.

- You can use **Head Job role** and **Compute Job role** to grant fine-grained IAM permissions to the Head Job and Compute Jobs

- You can add an execution role ARN to the **Batch execution role** field to grant permissions to make API calls on your behalf to the ECS container used by Batch. This is required if the pipeline launched with this compute environment needs access to the secrets stored in this workspace. This field can be ignored if you are not using secrets. 

- Specify an EBS block size (in GB) in the **EBS auto-expandable block size** field to control the initial size of the EBS auto-expandable volume. New blocks of this size are added when the volume begins to run out of free space. 

- Enter the **Boot disk size** (in GB) to specify the size of the boot disk in the VMs created by this compute environment. 
=======
>>>>>>> Stashed changes

- If you're using **Spot** instances, then you can also specify the **Cost percentage**, which is the maximum allowed price of a **Spot** instance as a percentage of the **On-Demand** price for that instance type. Spot instances will not be launched until the current spot price is below the specified cost percentage.

- You can use **AWS CLI tool path** to specify the location of the `aws` CLI.

<<<<<<< Updated upstream
- Specify a **Cloudwatch log group** for the `awslogs` driver to stream the logs entry to an existing Log group in Cloudwatch. 

- Specify a custom **ECS agent configuration** for the ECS agent parameters used by AWS Batch. This is appended to the /etc/ecs/ecs.config file in each cluster node. 

    !!! note
        Altering this file may result in a malfunctioning Tower Forge compute environment. See [Amazon ECS container agent configuration](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html) to learn more about the available parameters.

=======
>>>>>>> Stashed changes

## Manual

This section is for users with a pre-configured AWS environment. You will need a Batch queue, a Batch compute environment, an IAM user and an S3 bucket already set up.

To enable Tower within your existing AWS configuration, you need to have an IAM user with the following IAM permissions:

- `AmazonS3ReadOnlyAccess`
- `AmazonEC2ContainerRegistryReadOnly`
- `CloudWatchLogsReadOnlyAccess`

With these permissions set, we can add a new **AWS Batch** compute environment in Tower.

### Access to S3 Buckets

Tower can use S3 to store intermediate and output data generated by pipelines. We need to create a policy for our Tower IAM user that grants access to specific buckets.

1. Go to the IAM User table in the [IAM service](https://console.aws.amazon.com/iam/home)

2. Select the IAM user.

3. Select **Add inline policy**.


5. Name your policy and select **Create policy**.

### Compute Environment

To create a new compute environment for AWS Batch (without Forge):

1. In a workspace, select **Compute Environments** and then **New Environment**.

2. Enter a descriptive name for this environment, e.g. "AWS Batch Manual (eu-west-1)".

3. Select **Amazon Batch** as the target platform.


4. Add new credentials by selecting the **+** button.

5. Enter a name for the credentials, e.g. "AWS Credentials".

6. Enter the **Access key** and **Secret key** for your IAM user.

   ![](_images/aws_keys.png)

   !!! tip "Multiple credentials"
   You can create multiple credentials in your Tower environment. See the [Credentials](../credentials/overview.md) section.

7. Select a **Region**, e.g. "eu-west-1 - Europe (Ireland)"

8. Enter an S3 bucket path for the **Pipeline work directory**, for example `s3://tower-bucket`

9. Set the **Config mode** to **Manual**.

10. Enter the **Head queue**, which is the name of the AWS Batch queue that the Nextflow driver job will run.

11. Enter the **Compute queue**, which is the name of the AWS Batch queue that tasks will be submitted to.

12. You can use the **Environment variables** option to specify custom environment variables for the Head job and/or Compute jobs.

13. Configure any advanced options described below, as needed.

14. Select **Create** to finalize the compute environment setup.

    ![](_images/aws_new_env_manual_config.png)

Jump to the documentation for [Launching Pipelines](../launch/launchpad.md).

#### Advanced options

- You can use **Head Job CPUs** and **Head Job Memory** to specify the hardware resources allocated for the Head Job.

- You can use **Head Job role** and **Compute Job role** to grant fine-grained IAM permissions to the Head Job and Compute Jobs

- You can use **AWS CLI tool path** to specify the location of the `aws` CLI.

- You can specify a custom **ECS agent configuration**. The content of this field is appended to the `/etc/ecs/ecs.config` file in each cluster node. Note that altering this file may result in a malfunctioning Tower Forge compute environment. See [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html) for more information about the available parameters.
