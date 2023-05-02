---
layout: ../../layouts/HelpLayout.astro
title: "Fusion file system"
description: "Overview of Fusion file system in Tower."
date: "24 Apr 2023"
tags: [fusion, file system, storage]
---

## Fusion file system

Tower 22.4 adds official support for the Fusion file system. 

Fusion is a lightweight container-based client that enables containerized tasks to access data in Amazon S3 using POSIX file access semantics. Depending on your data handling requirements, Fusion 2.0 can improve pipeline throughput, which should reduce cloud computing costs. See [here](https://www.nextflow.io/docs/latest/fusion.html#fusion-file-system) for more information on Fusion's features. 

## Performance vs. cost considerations (highlight NVMe vs. pure EBS)

Network throttling on smaller instances effectively negates the Fusion benefit. 

!!! note
    Regardless of NVMe or EBS path chosen, manual or forge, instance networking performance has a considerable impact on Fusion v2's performance. We recommend 8xlarge or above for large production pipelines in order to see pipeline performance... 

## Configuration details (+ links to NF docs, etc.)

### Tower Forge with NVMe (recommended)

1. For this configuration, use Tower version 23.1 or later. 
2. Create an AWS Batch compute environment using Tower Forge. 
3. Enable Wave containers, Fusion v2, and fast instance storage. 
4. Select your Instance types under Advanced options:
    - If left unspecified, Tower will select the following instance type families: ['c5ad', 'c5d', 'c6id', 'i3', 'i4i', 'm5ad', 'm5d', 'm6id', 'r5ad', 'r5d', 'r6id']
    - To specify an NVMe instance family type, select from the following: 
        - Intel:['c5ad','c5d','c6id','dl1','f1','g4ad','g4dn','g5','i3','i3en','i4i''m5ad','m5d','m5dn','m6id','p3dn','p4d','p4de','r5ad','r5d','r5dn','r6id','x2idn','x2iedn','z1d']
        - Arm: ['c6gd', 'm6gd', 'r6gd', 'x2gd','im4gn','is4gen'] Jordi questions

    !!! note "Optimal instance type families will not work with NVMe"
        When enabling fast instance storage, do not select the `optimal` instance type families (r4, c4, m4) for your compute environment as these are not NVMe-based instances. Specify the instance types listed above.

!!! note
    We recommend selecting 8xlarge or above for large and long-lived production pipelines. Dedicated networking ensures a guaranteed network speed service level compared with "burstable" instances. (Link to AWS to follow)

5. Use S3 as the pipeline work directory, Fusion does not support other storage media. 

### Tower Forge EBS only

1. For this configuration, use Tower version 23.1 or later. 
2. Create an AWS Batch compute environment using Tower Forge. 
3. Enable Wave containers, Fusion v2. 
4. When you choose to use Fusion without fast instance storage, the following EBS settings are applied:

    - Nextflow configuration adds `process.scratch = false`
    - EBS autoscale is disabled
    - EBS boot disk size is increased to 100GB
    - EBS boot disk type is changed to GP3
    - EBS boot disk throughput is increased to 325MB/s

5. Use S3 as the pipeline work directory, Fusion does not support other storage media. 

### Manual CE with and without NVMe (later)

### K8s, GCP, etc. (later)

<!--- keeping notes for future updates>
# @Llewellyn - Thougtht and feedback 
1. I think we want to be more prescriptive to our commercial customers. Existing documentation (i.e. blog post and original content on this page) is wishy-washy re: recommended storage: blog shows lousy EBS-based Fusion run alongside NVME. This content originally had NVME usage as optional. [Nextflow fusion](https://www.nextflow.io/docs/latest/fusion.html#nvme-storage) page recommends NVME for max performance but that's in the 3rd paragraph of the bottom section.

2. Networking is assumed to be reliable and continuous. This is not always true in a cloud environment. We do not talk about it but I'm convinced our paying clients will encounter this problem. TBD whether that goes here or should be added to the Nextflow Fusion docs (I've kept it here for now).

3. Batch Forge offers a **Boot disk size** option which I can't find in the docs. We seem to force 50GB at least, and if larger numbers are specified it makes initial AWS EC2 initializational glacial. This will impact perceived performance (for storage that I'm under the impression isn't required). There should probably be a warning.

4. Tower Forge has undocumented features when creating an AWS Batch NVME environment:
    1. If instances are selected, these default families are used: ['c5ad', 'c5d', 'c6id', 'i3', 'i4i', 'm5ad', 'm5d', 'm6id', 'r5ad', 'r5d', 'r6id']
        (Turns out this is covered in pt 15 of https://help.tower.nf/22.4/compute-envs/aws-batch/#compute-environment).
    2. Tower supports a wider list of AWS NVMEs, which seem distributed across Intel and ARM. On first glance, this seems to cover all NVME types within AWS but it would be good to confirm, and to elaborate on why this list exists / how it is used.
        - Intel:['c5ad','c5d','c6id','dl1','f1','g4ad','g4dn','g5','i3','i3en','i4i''m5ad','m5d','m5dn','m6id','p3dn','p4d','p4de','r5ad','r5d','r5dn','r6id','x2idn','x2iedn','z1d']
        - Arm: [ 'c6gd', 'm6gd', 'r6gd', 'x2gd','im4gn','is4gen' ]

5. There are two different "Create AWS Batch CE Manually" instruction sets:
    - https://help.tower.nf/22.4/compute-envs/aws-batch/#manual
    - https://install.tower.nf/22.4/advanced-topics/manual-aws-batch-setup/

    The install site has an ancient Launch Template that won't work for NVME.
    I don't see a Launch Template called out in the help docs.
    I've attached a Launch Template below that we use to get Fusion running on a manually-built AWS Batch env. This opens a bigger can of works since we have other components in there
    like the CloudWatch Agent (which I think should be included but means revamping the Manual build docs).

6. The Nextflow docs are (I think), intermingling AWS-specific configuration (`aws.batch.volumes`) with Nextflow-specific configuration (`process.scratch`).
    See: [https://www.nextflow.io/docs/latest/fusion.html#nvme-storage](https://www.nextflow.io/docs/latest/fusion.html#nvme-storage)

7. A Tower launch automatically adds `wave.enabled=true` and `fusion.enabled=true` to the Nextflow config. 
    - In some ways, I'm opinionated and think it should be added explicitly no matter way.
    - From a Tower Launch perspective, the necessary config could be put in the nextflow.config / pipeline launch screen / or during CE creation. Since we are having to specify NVME-type machines for the CE, I assume we'd probably want to define this at the CE level (making it DRY). Is this the company position?

8. Jordi provided some additional description on how Fusion behaves. I don't think it belongs here, but there may be a desire to augment the Nextflow Fusion docs.**



## Infrastructure Dependencies
Fusion was designed with the expectation of fast storage and consistent network speeds. For optimal results, implementors are advised to provision:

- Compute instances backed by [local NVME volumes](https://www.nextflow.io/docs/latest/fusion.html#nvme-storage).

- Compute instances with dedicated networking service levels.
    Details: AWS [available instance bandwidth](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-network-bandwidth.html)

- Don't modify the EBS initial boot disk size beyond 50GB.
    TO DO: Describe why.

For more details on infrastructure options and expectations, please see [Breakthrough performance and cost-efficiency with the new Fusion file system](https://seqera.io/blog/breakthrough-performance-and-cost-efficiency-with-the-new-fusion-file-system/#introducing-fusion-file-system). 


### Wave Dependency
Access to the Fusion binary is contingent upon integration with Seqera's [Wave service](https://www.nextflow.io/docs/latest/wave.html).


### Nextflow Tower 

#### 1. Configure Tower to connect to Wave

=== "Tower Enterprise"

    1. Please see [https://install.tower.nf/configuration/wave/](https://install.tower.nf/22.4/configuration/wave/) for additional configuration settings for your Tower Enteprise implementation.

=== "Tower Cloud"

    1. N/A. Tower Cloud is already configured to use the Wave service.


#### 2. Create a Fusion-enable AWS Batch Compute Environment


TO DO: Warning about EBS Initial Bootdisk size: Don't expand it or it will dramatically slow down your runs.

=== "AWS Batch Forge"

    1. Enable the [Wave containers service](https://www.nextflow.io/docs/latest/wave.html#wave-page) during [AWS Batch](/docs/compute-envs/aws-batch.md) compute environment creation.

    2. Select **Enable Fusion v2** during compute environment creation. 

    3. Select **Enable fast instance storage** to make use of NVMe instance storage to further increase performance. 

=== "AWS Batch Manual Import"

    1. Create the AWS Batch Compute Environment as per [https://install.tower.nf/22.4/advanced-topics/manual-aws-batch-setup/](https://install.tower.nf/22.4/advanced-topics/manual-aws-batch-setup/)
    ** NOTE: THESE INSTRUCTIONS ARE SUPER OLD. MUST BE UPDATED.**

    2. Use the following EC2 Launch Template to ensure NVME volumes are available to you.
        ```
        MIME-Version: 1.0
        Content-Type: multipart/mixed; boundary="//"

        --//
        Content-Type: text/cloud-config; charset="us-ascii"

        #cloud-config
        write_files:
        - path: /root/tower-forge.sh
            permissions: 0744
            owner: root
            content: |
            #!/usr/bin/env bash
            exec > >(tee /var/log/tower-forge.log|logger -t TowerForge -s 2>/dev/console) 2>&1
            
            ## Install necessary packages
            yum install -q -y jq sed wget unzip nvme-cli lvm2

            ## Install Cloudwatch Agent for easier EC2 instantiation troubleshooting
            wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
            rpm -U ./amazon-cloudwatch-agent.rpm
            rm -f ./amazon-cloudwatch-agent.rpm
            curl -s https://nf-xpack.seqera.io/amazon-cloudwatch-agent/config-v0.3.json \
                | sed 's/$FORGE_ID/NAME_OF_YOUR_BATCH_CLUSTER/g' \
                > /opt/aws/amazon-cloudwatch-agent/bin/config.json
            /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

            ## Make NVME volumes accessible to Nextflow Compute Tasks
            mkdir -p /scratch/fusion
            NVME_DISKS=($(nvme list | grep 'Amazon EC2 NVMe Instance Storage' | awk '{ print $1 }'))
            NUM_DISKS=${#NVME_DISKS[@]}
            if (( NUM_DISKS > 0 )); then
                if (( NUM_DISKS == 1 )); then
                mkfs -t xfs ${NVME_DISKS[0]}
                mount ${NVME_DISKS[0]} /scratch/fusion
                else
                pvcreate ${NVME_DISKS[@]}
                vgcreate scratch_fusion ${NVME_DISKS[@]}
                lvcreate -l 100%FREE -n volume scratch_fusion
                mkfs -t xfs /dev/mapper/scratch_fusion-volume
                mount /dev/mapper/scratch_fusion-volume /scratch/fusion
                fi
            fi

            ## Add ECS Agent Modifications
            mkdir -p /etc/ecs
            echo ECS_IMAGE_PULL_BEHAVIOR=once >> /etc/ecs/ecs.config
            echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config

            ## Install the AWS CLI
            systemctl stop docker
            mkdir -p /home/ec2-user
            curl -s https://nf-xpack.seqera.io/miniconda-awscli/miniconda-awscli.tar.gz \
            | tar xz -C /home/ec2-user
            export PATH=$PATH:/home/ec2-user/miniconda/bin
            ln -s /home/ec2-user/miniconda/bin/aws /usr/bin/aws

            ## Restart Docker and ECS Agent
            systemctl start docker
            systemctl enable --now --no-block ecs

            ## Mitigate kernel bug
            echo "1258291200" > /proc/sys/vm/dirty_bytes
            echo "629145600" > /proc/sys/vm/dirty_background_bytes

        runcmd:
        - bash /root/tower-forge.sh

        --//--
        ```

#### 3. Configure the Nextflow Pipeline

Use Nextflow version `22.10.0` or later. The latest version of Nextflow is used in Tower by default, but a particular version can be specified using `NXF_VER` in the Nextflow config file field (**Advanced options -> Nextflow config file** under Pipeline settings on the launch page). 

=== "Tower Launch"

    1. Add the following configuration values to your *nextflow.config*:
        ```
        aws.batch.volumes = '/scratch/fusion:/tmp' 
        process.scratch = false
        ```

=== "Nextflow CLI Launch"

    1. Add the following configuration values to your *nextflow.config*:
        ```
        wave.enabled = true 
        fusion.enabled = true 
        aws.batch.volumes = '/scratch/fusion:/tmp' 
        process.scratch = false
        ```




## Additional notes on Fusion behaviour from Jordi

Tower 22.4 adds official support for the Fusion file system. Fusion is a lightweight client that enables containerized tasks to access data in Amazon S3 (and other object stores in future) using POSIX file access semantics. Depending on your data handling requirements, Fusion 2.0 improves pipeline throughput and/or reduces cloud computing costs. See [here](https://seqera.io/fusion/) for more information on Fusion's features.

### Fusion requirements

Fusion is run inside the container, this is why it trys to minimize memory usage and uses a disk baked cache to temporally store in file chunks downloaded/uploaded from S3. By default is using temporal folder "/tmp" in the instance as disk cache.

At Tower when you only select wave + fusion this temporal folder is backed by an EBS autoscale disk. And by default Nextflow uses `process.scratch = true`, that means that the process is going to run also in a temporal folder at "/tmp" (same EBS autoscale). So when you do a "cat /fusion/s3/bucket/myfile.txt > myfile.txt" at Nextflow script this means that Fusion downloads the file from S3 into chunks at "/tmp" folder, then Fusion serves the file to the process from "/tmp" folder and finally the process writes back the file also to "/tmp" folder. As you can see this is not optimal because we are doing too many EBS reads and writes.

Fusion file system is designed to work with containerised workloads. Therefore, it requires the use of a container-native platform for the execution of your pipeline. Currently, Fusion is only available in AWS Batch compute environments in Tower.

To enable Fusion in Tower:

- Use Nextflow version `22.10.0` or later. The latest version of Nextflow is used in Tower by default, but a particular version can be specified using `NXF_VER` in the Nextflow config file field (**Advanced options -> Nextflow config file** under Pipeline settings on the launch page).

But when you also select "fast storage" option NVMe disk is mounted as "/tmp" in the container and also "process.scratch" is set to "false". So in this setup when you do a "cat /fusion/s3/bucket/myfile.txt > myfile.txt" Fusion is in background downloading file chunks from S3 to NVMe, then Fusion serves the file to the process from NVMe and finally the process writes back the file directly to Fusion (and Fusion stores it to NVMe and will upload it to S3 on background). In this way all the data flow is more optimized and only read/write once to NVMe disk.

Fusion is a FUSE filesystem and works at user level, this is why you see a significant increase in the number of voluntary context switches (because there are many switch between Kernel and the Fusion process that is serving the FUSE interface). You will see same increase with anyother FUSE file system. At the level of Kernel the performance of FUSE filesystems has been highly optimize during last decade and currently it's not a performance problem, also other HPC solutions are starting to use it. 

If you see a slower real time execution is because when using Fusion you need to do the download and upload of S3 while the process is running, without Fusion the download and upload are done outside this real time execution. So, if your process is only doing reading and writing files at maximum capacity, then it's expected that the real time can be bigger because Fusion is doing more things on background. But if your process does something else than reading and writing files at maximum capacity, then Fusion will be able to give you similar timings taking advant

- Select **Enable Fusion v2** during compute environment creation.

- (Optional) Select **Enable fast instance storage** to make use of NVMe instance storage to further increase performance.


See the [AWS Batch](/docs/compute-envs/aws-batch.md#) compute environment page for detailed instructions.
