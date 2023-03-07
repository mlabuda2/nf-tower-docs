---
description: 'Fusion file system'
---

Tower 22.4 adds official support for the Fusion file system. 

Fusion is a lightweight container-based client that enables containerized tasks to access data in Amazon S3 using POSIX file access semantics. Depending on your data handling requirements, Fusion 2.0 can improve pipeline throughput, which should reduce cloud computing costs. See [here](https://seqera.io/fusion/) for more information on Fusion's features. 

## How does Fusion provide pipeline efficiency?
Traditional S3-based Nextflow pipelines must wait for all input objects to fully copy to the compute container before a task can begin, and can only begin stage out activities when the compute task is complete. This can cause lengthy delays in the following segments of your compute container's lifecycle:

1. Container start -> **Stage in** -> Task start
2. Task completeion -> **Stage out** -> Container stop

Fusion executes as a background file-streaming solution which downloads input file chunks on demand and eagerly uploads output file chunks as they become available. This behaviour compresses the stage in and stage out phases, resulting in: 

1. Shorter task container lifespans.
2. Shorter virtual machine rental time.
3. Quicker time-to-completion.
3. Net cost savings for your organization.


## Workload Suitability

### Why fusion?
Lustre speeds at S3 prices. And you save money. Works best for I/O-heavy pipelines which only use a subset of the downloaded materials.



## Infrastructure Dependencies
### Which platforms support Fusion? 
Fusion is currently supported on the following platforms:
- AWS
- ?

### What infrastructure is most optimal for Fusion-based pipelines?
Fusion was designed with the expectation of fast storage and consistent network speeds. For optimal results, implementors are advised to provision:

- **Compute instances backed by local NVME volumes.**
    Examples: AWS [EC2 instance store](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html)

- Compute instances with dedicated networking service levels.
    Details: AWS [available instance bandwidth](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-network-bandwidth.html)

- Don't modify the EBS initial bootdisk size beyond 50GB.
    TO DO: Describe why.

For more details on infrastructure options and expectations, please see [Breakthrough performance and cost-efficiency with the new Fusion file system](https://seqera.io/blog/breakthrough-performance-and-cost-efficiency-with-the-new-fusion-file-system/#introducing-fusion-file-system). 


### What is Fusion's relationship to Wave?
The Fusion binary must be executed from within your compute containers. Seqera's Wave service acts as a container augmentation service - it retrieves your image manifest from the original target container repository and augments the manifest with additional container layers (supplied by Seqera Labs). This makes the Fusion binary avaiable to your container at runtime without requiring you to rebuild any containers.

## Benchmarking
### What is the best way to benchmark Fusion? <@ROB S)>
Prior to running benchmarks on your own in-house pipelines, we advise an initial calibration run using the <PIPELINE-NAME-HERE> in order to:

1. Verify the delta between a traditional S3 execution vs Fusion execution.
2. Ensure your environment is properly configured to execute benchmarks on your own pipelines.

<ADD SNIPPET HERE ABOUT WHERE TO LOOK IN A RUN TO SEE FUSION'S BENEFITS>


## Configuration
I'm sold! How can I execute my own Fusion run?

### Nextflow Tower 

#### 1. Configure Tower to connect to Wave

=== "Tower Enterprise"

    1. Add the following configuration values to [Docker-Compose *tower.yml*](https://install.tower.nf/22.4/docker-compose/#deploy-tower) / [K8s ConfigMap](https://install.tower.nf/22.4/kubernetes/#tower-configmap):
        ```
        TOWER_ENABLE_WAVE=true
        WAVE_SERVER_URL=https://wave.seqera.io
        ```

=== "Tower Cloud"

    1. N/A. Tower Cloud is already configured to use the Wave service.


#### 2. Create a Fusion-enable AWS Batch Compute Environment

**ADD text here describing which instances will be chosen for you by default vs what the full list of supported instances are. CALL OUT difference between X64 and ARM.
Last time I checked:
Default instances: ['c5ad', 'c5d', 'c6id', 'i3', 'i4i', 'm5ad', 'm5d', 'm6id', 'r5ad', 'r5d', 'r6id']
All instances supporter:
- Intel:['c5ad','c5d','c6id','dl1','f1','g4ad','g4dn','g5','i3','i3en','i4i''m5ad','m5d','m5dn','m6id','p3dn','p4d','p4de','r5ad','r5d','r5dn','r6id','x2idn','x2iedn','z1d']
- Arm: [ 'c6gd', 'm6gd', 'r6gd', 'x2gd','im4gn','is4gen' ]**

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




## Fusion requirements

Fusion file system is designed to work with containerised workloads. Therefore, it requires the use of a container-native platform for the execution of your pipeline. Currently, Fusion is only available in AWS Batch compute environments in Tower. 


Fusion is run inside the container, this is why it trys to minimize memory usage and uses a disk baked cache to temporally store in file chunks downloaded/uploaded from S3. By default is using temporal folder "/tmp" in the instance as disk cache.

At Tower when you only select wave + fusion this temporal folder is backed by an EBS autoscale disk. And by default Nextflow uses `process.scratch = true`, that means that the process is going to run also in a temporal folder at "/tmp" (same EBS autoscale). So when you do a "cat /fusion/s3/bucket/myfile.txt > myfile.txt" at Nextflow script this means that Fusion downloads the file from S3 into chunks at "/tmp" folder, then Fusion serves the file to the process from "/tmp" folder and finally the process writes back the file also to "/tmp" folder. As you can see this is not optimal because we are doing too many EBS reads and writes.

But when you also select "fast storage" option NVMe disk is mounted as "/tmp" in the container and also "process.scratch" is set to "false". So in this setup when you do a "cat /fusion/s3/bucket/myfile.txt > myfile.txt" Fusion is in background downloading file chunks from S3 to NVMe, then Fusion serves the file to the process from NVMe and finally the process writes back the file directly to Fusion (and Fusion stores it to NVMe and will upload it to S3 on background). In this way all the data flow is more optimized and only read/write once to NVMe disk.

Fusion is a FUSE filesystem and works at user level, this is why you see a significant increase in the number of voluntary context switches (because there are many switch between Kernel and the Fusion process that is serving the FUSE interface). You will see same increase with anyother FUSE file system. At the level of Kernel the performance of FUSE filesystems has been highly optimize during last decade and currently it's not a performance problem, also other HPC solutions are starting to use it. 

If you see a slower real time execution is because when using Fusion you need to do the download and upload of S3 while the process is running, without Fusion the download and upload are done outside this real time execution. So, if your process is only doing reading and writing files at maximum capacity, then it's expected that the real time can be bigger because Fusion is doing more things on background. But if your process does something else than reading and writing files at maximum capacity, then Fusion will be able to give you similar timings taking advant

See the [AWS Batch](/docs/compute-envs/aws-batch.md#) compute environment page for detailed instructions.