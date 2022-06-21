---
title: Frequently Asked Questions
headline: "FAQ"
description: 'Frequestly Asked Questions'
---

## General Questions

### Administration Console

**<p data-question>Q: How do I access the Administration Console?</p>**

The Administration Console allows Tower instance administrators to interact with all users and organizations registered with the platform. Administrators must be identified in your Tower instance configuration files prior to instantiation of the application.

1. Create a `TOWER_ROOT_USERS` environment variable (e.g. via _tower.env_).
2. Populate the variable with a sequence of comma-delimited email addresses (no spaces).<br>Example: `TOWER_ROOT_USERS=foo@foo.com,bar@bar.com`
3. If using a Tower version earlier than 21.12: 
    1. Add the following configuration to _tower.yml_:
    ```yml
    tower:
      admin:
        root-users: '${TOWER_ROOT_USERS:[]}'
    ```
4. Restart the application.
5. The console will now be availabe via your Profile drop-down menu.


### Common Errors

**<p data-question>Q: After following the log-in link, why is my screen frozen at `/auth?success=true`?</p>**

Starting with v22.1, Tower Enterprise implements stricter cookie security by default and will only send an auth cookie if the client is connected via HTTPS. The lack of an auth token will cause HTTP-only log-in attempts to fail (thereby causing the frozen screen).

To remediate this problem, set the following environment variable `TOWER_ENABLE_UNSAFE_MODE=true`.

**<p data-question>Q: "Unknown pipeline repository or missing credentials" error when pulling from a public Github repository?</p>**

Github imposes [rate limits](https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting) on repository pulls (including public repositories), where unauthenticated requests are capped at 60 requests/hour and authenticated requests are capped at 5000/hour. Tower users tend to encounter this error due to the 60 request/hour cap. 

To resolve the problem, please try the following:

  1. Ensure there is at least one Github credential in your Workspace's Credentials tab.
  2. Ensure that the **Access token** field of all Github Credential objects is populated with a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) value, NOT a user password. (_Github PATs are typically several dozen characters long and begin with a `ghp_` prefix; example: `ghp_IqIMNOZH6zOwIEB4T9A2g4EHMy8Ji42q4HA`_)
  3. Confirm that your PAT is providing the elevated threshold and transactions are being charged against it: 
  
        `curl -H "Authorization: token ghp_LONG_ALPHANUMERIC_PAT" -H "Accept: application/vnd.github.v3+json" https://api.github.com/rate_limit`


**<p data-question>Q: "Unexpected error sending mail ... TLS 1.0 and 1.1 are not supported. Please upgrade/update your client to support TLS 1.2" error?</p>**

Some mail services, including Microsoft, have phased out support for TLS 1.0 and 1.1. Tower Enterprise, however, is based on Java 11 (Amazon Coretto) and does not use TLSv1.2 by default. As a result, an encryption error will occur when Tower tries to send email even if you have configured your `mail.smtp.starttls` settings to be `true`.

To fix the problem, use this JDK environment variable to force the usage of TLSv1.2 by default:

    `_JAVA_OPTIONS="-Dmail.smtp.ssl.protocols=TLSv1.2"`



**<p data-question>Q: "Row was updated or deleted by another transaction (or unsaved-value mapping was incorrect)" error.**

This error can occur if incorrect configuration values are assigned to the `backend` and `cron` containers' `MICRONAUT_ENVIRONMENTS` environment variable. You may see other unexpected system behaviour like two exact copies of the same Nextflow job be submitted to the Executor for scheduling. 

Please verify the following:

1. The `MICRONAUT_ENVIRONMENTS` environment variable associated with the `backend` container:
    * Contains `prod,redis,ha`
    * Does not contain `cron`
2. The `MICRONAUT_ENVIRONMENTS` environment variable associated with the `cron` container:
    * Contains `prod,redis,cron`
    * Does not contain `ha`
3. You do not have another copy of the `MICRONAUT_ENVIRONMENTS` environment variable defined elsewhere in your application (e.g. a _tower.env_ file or Kubernetes ConfigMap).
4. If you are using a separate container/pod to execute _migrate-db.sh_, there is no `MICRONAUT_ENVIRONMENTS` environment variable assigned to it.


**<p data-question>Q: "No such variable" error.</p>**

This error can occur if you execute a DSL 1-based Nextflow workflow using [Nextflow 22.03.0-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.03.0-edge) or later.


### Compute Environments

**<p data-question>Q: Can the name of a Compute Environment created in Tower contain special characters?**

No. Tower version 21.12 and later do not support the inclusion of special characters in the name of Compute Environment objects.


**<p data-question>Q: How do I set NXF_OPTS values for a Compute Environment?**

This depends on your Tower version:

  * For v22.1.1+, specify the values via the **Environment variables** section of the "Add Compute Environment" screen.
  * For versions earlier than v22.1.1, specify the values via the **Staging options > Pre-run script** textbox on the "Add Compute Environment" screen. Example: 
    
    `export NXF_OPTS="-Xms64m -Xmx512m"`


### Configuration

**<p data-question>Q: Can a custom path be specified for the `tower.yml` configuration file?</p>**

Yes. Provide a POSIX-compliant path to the `TOWER_CONFIG_FILE` environment variable.


**<p data-question>Q: Why do parts of `tower.yml` not seem to work when I run my Tower implementation?</p>**
    
There are two reasons why configurations specified in `tower.yml` are not being expressed by your Tower instance:

1. There is a typo in one of the key value pairs.
2. There is a duplicate key present in your file. 
    ```yaml
    # EXAMPLE
    # This block will not end up being enforced because there is another `tower` key below.
    tower:
      trustedEmails:
        - user@example.com

    # This block will end up being enforced because it is defined last.
    tower:
      auth:
        oidc:
          - "*@foo.com"
    ```


**<p data-question>Q: Do you have guidance on how to create custom Nextflow containers?</p>**

Yes. Please see [https://github.com/seqeralabs/gatk4-germline-snps-indels/tree/master/containers](https://github.com/seqeralabs/gatk4-germline-snps-indels/tree/master/containers).


**<p data-question>Q: What DSL version does Nextflow Tower set as default for Nextflow head jobs?**

As of [Nextflow 22.03.0-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.03.0-edge), DSL2 is the default syntax.

To minimize disruption on existing pipelines, Nextflow Tower version 22.1.x and later are configured to default Nextflow head jobs to DSL 1 for a transition period (ending TBD).

You can force your Nextflow head job to use DSL2 syntax via any of the following techniques:

* Adding `export NXF_DEFAULT_DSL=2` in the **Advanced Features > Pre-run script** field of Tower Launch UI.
* Specifying `nextflow.enable.dsl = 2` at the top of your Nextflow workflow file.
* Providing the `-dsl2` flag when invoking the Nextflow CLI (e.g. `nextflow run ... -dsl2`)


**<p data-question>Q: Can Tower to use a Nextflow workflow stored in a local git repository?</p>**

Yes. As of v22.1, Nextflow Tower Enterprise can link to workflows stored in "local" git repositories. To do so:

1. Volume mount your repository folder into the Tower Enterprise `backend` container.
2. Update your `tower.yml` with the following configuration:
```yml
tower:
  pipeline:
    allow-local-repos:
      - /path/to/repo
```

Note: This feature is not available to Tower Cloud users.


**<p data-question>Q: Am I forced to define sensitive values in `tower.env`?</p>**
No. You can inject values directly into `tower.yml` or - in the case of a Kubernetes deployment - reference data from a secrets manager like Hashicorp Vault.

Please contact Seqera Labs for more details if this is of interest.


### Containers

**<p data-question>Q: Can I use rootless containers in my Nextflow pipelines?</p>**

Most containers use the root user by default. However, some users prefer to define a non-root user in the container in order to minimize the risk of privilege escalation. Because Nextflow and its tasks use a shared work directory to manage input and output data, using rootless containers can lead to file permissions errors in some environments:
```
touch: cannot touch '/fsx/work/ab/27d78d2b9b17ee895b88fcee794226/.command.begin': Permission denied
```

As of Tower 22.1.0 or later, this issue should not occur when using AWS Batch. In other situations, you can avoid this issue by forcing all task containers to run as root. To do so, add one of the following snippets to your Nextflow configuration:
```
// cloud executors
process.containerOptions = "--user 0:0"

// Kubernetes
k8s.securityContext = [
  "runAsUser": 0,
  "runAsGroup": 0
]
```

### Logging

**<p data-question>Q: Can Tower enable detailed logging related to sign-in activity?**

Yes. For more detailed logging related to login events, set the following environment variable: `TOWER_SECURITY_LOGLEVEL=DEBUG`.


**<p data-question>Q: Can Tower enable detailed logging related to application activites?**

Yes. For more detailed logging related to application activities, set the following environment variable: `TOWER_LOG_LEVEL=TRACE`.


### Login

**<p data-question>Q: Can I completely disable Tower's email login feature?</p>**

The email login feature cannot be completely removed from the Tower login screen. 


**<p data-question>Q: How can I restrict Tower access to only a subset of email addresses?</p>**

You can restrict which emails are allowed to have automatic access to your Tower implementation via a configuration in _tower.yml_. 

Users without automatic access will receive an acknowledgment of their login request but be unable to access the platform until approved by a Tower administration via the Administrator Console.
```yaml
# This any email address that matches a pattern here will have automatic access.
tower:
  trustedEmails:
    - '*@seqera.io`
    - 'named_user@example.com'
```


**<p data-question>Q: Why is my OIDC redirect_url set to http instead of https?</p>**

This can occur for several reasons. Please verify the following:

1. Your `TOWER_SERVER_URL` environment variable uses the `https://` prefix.
2. Your `tower.yml` has `micronaut.ssl.enabled` set to `true`.
3. Any Load Balancer instance that sends traffic to the Tower application is configured to use HTTPS as its backend protocol rather than TCP.


**<p data-question>Q: Why isn't my OIDC callback working?</p>**

Callbacks could fail for many reasons. To more effectively investigate the problem: 

1. Set the Tower environment variable to `TOWER_SECURITY_LOGLEVEL=DEBUG`.
2. Ensure your `TOWER_OIDC_CLIENT`, `TOWER_OIDC_SECRET`, and `TOWER_OIDC_ISSUER` environment variables all match the values specified in your OIDC provider's corresponding application.
3. Ensure your network infrastructure allow necessary egress and ingress traffic.


**<p data-question>Q: Why did Google SMTP start returning `Username and Password not accepted` errors?</p>**
Previously functioning Tower Enterprise email integration with Google SMTP are likely to encounter errors as of May 30, 2022 due to a [security posture change](https://support.google.com/accounts/answer/6010255#more-secure-apps-how&zippy=%2Cuse-more-secure-apps) implemented by Google.

To reestablish email connectivity, please follow the instructions at [https://support.google.com/accounts/answer/3466521](https://support.google.com/accounts/answer/3466521) to provision an app password. Update your `TOWER_SMTP_PASSWORD` environment variable with the app password, and restart the application.


### Miscellaneous

**<p data-question>Q: Is my data safe?</p>**

Yes, your data stays strictly within **your** infrastructure itself. When you launch a workflow through Tower, you need to connect your infrastructure (HPC/VMs/K8s) by creating the appropriate credentials and compute environment in a workspace.

Tower then uses this configuration to trigger a Nextflow workflow within your infrastructure similar to what is done via the Nextflow CLI, therefore Tower does not manipulate any data itself and no data is transferred to the infrastructure where Tower is running.


### Monitoring

**<p data-question>Q: Can Tower integrate with 3rd party Java-based Application Performance Monitoring (APM) solutions?</p>**

Yes. You can mount the APM solution's JAR file in the `backend` container and set the agent JVM option via the `JAVA_OPTS` env variable.


**<p data-question>Q: Is it possible to retrieve the trace file for a Tower-based workflow run?</p>**
Yes. Although it is not possible to directly download the file via Tower, you can configure your workflow to export the file to persistent storage:

1. Set the following block in your `nextflow.config`:
```nextflow
trace {
    enabled = true
}
```

2. Add a copy command to your pipeline's **Advanced options > Post-run script** field:
```
# Example: Export the generated trace file to an S3 bucket
# Ensure that your Nextflow head job has the necessary permissions to interact with the target storage medium!
aws s3 cp ./trace.txt s3://MY_BUCKET/trace/trace.txt
```


### Nextflow Configuration

**<p data-question>Q: Can a repository's `nextflow_schema.json` support multiple input file mimetypes?</p>**

No. As of April 2022, it is not possible to configure an input field ([example](https://github.com/nf-core/rnaseq/blob/master/nextflow_schema.json#L16-L21)) to support different mime types (e.g. a `text/csv`-type file during one execution, and a `text/tab-separated-values` file in a subsequent run).


**<p data-question>Q: Why are my `--outdir` artefacts not available when executing runs in a cloud environment?</p>**

As of April 2022, Nextflow resolves relative paths against the current working directory. In a classic grid HPC, this normally corresponds to a subdirectory of the user's $HOME directory. In a cloud execution environment, however, the path will be resolved relative to the **container file system** meaning files will be lost when the container is termination. [See here for more details](https://github.com/nextflow-io/nextflow/issues/2661#issuecomment-1047259845).

Tower Users can avoid this problem by specifying the following configuration in the **Advanced options > Nextflow config file** configuration textbox: `params.outdir = workDir + '/results`. This will ensure the output files are written to your stateful storage rather than ephemeral container storage.


**<p data-question>Q: Can Nextflow be configured to ignore a Singularity cache?</p>**

Yes. To ignore the Singularity cache, add the following configuration item to your workflow: `process.container = 'file:///some/singularity/image.sif'`.


**<p data-question>Q: Why does Nextflow fail with a `WARN: Cannot read project manifest ... path=nextflow.config` error message?</p>**

This error can occur when executing a pipeline where the source git repository's default branch is not populated with `main.nf` and `nextflow.config` files, regardles of whether the invoked pipeline is using a non-default revision/branch (e.g. `dev`). 

Current as of May 16, 2022, there is no solution for this problem other than to create blank `main.nf` and `nextflow.config` files in the default branch. This will allow the pipeline to run, using the content of the `main.nf` and `nextflow.config` in your target revision.


**<p data-question>Q: Is it possible to maintain different Nextflow configuration files for different environments?</p>**

Yes. The main `nextflow.config` file will always be imported by default. Instead of managing multiple `nextflow.config` files (each customized for an environment), you can create unique environment config files and import them as [their own profile](https://www.nextflow.io/docs/latest/config.html#config-profiles) in the main `nextflow.config`.

Example:
```
// nextflow.config

<truncated>

profiles {
    test { includeConfig 'conf/test.config' }
    prod { includeConfig 'conf/prod.config' }
    uat  { includeConfig 'conf/uat.config'  }    
}

<truncated>
```


### Nextflow Launcher

**<p data-question>Q: There are several nf-launcher images available in the [Seqera image registry](https://quay.io/repository/seqeralabs/nf-launcher?tab=tags). How can I tell which one is most appropriate for my implementation?</p>**

Your Tower implementation knows the nf-launcher image version it needs and will specify this value automatically when launching a pipeline. 

If you are restricted from using public container registries, please see Tower Enterprise Release Note instructions ([example](https://install.tower.nf/22.1/release_notes/22.1/#nextflow-launcher-image)) for the specific image you should use and how to set this as the default when invoking pipelines. 


### Plugins

**<p data-question>Q: Is it possible to use the Nextflow SQL DB plugin to query AWS Athena?</p>**

Yes. As of [Nextflow 22.05.0-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.05.0-edge), your Nextflow pipelines can query data from AWS Athena.
You must add the following configuration items to your `nextflow.config` (**Note:** the use of secrets is optional):
```
plugins {
  id 'nf-sqldb@0.4.0'
}

sql {
    db {
        'athena' {
              url = 'jdbc:awsathena://AwsRegion=YOUR_REGION;S3OutputLocation=s3://YOUR_S3_BUCKET'
              user = secrets.ATHENA_USER
              password = secrets.ATHENA_PASSWORD
            }
    }
}
```

You can then call the functionality from within your workflow.
```
// Example
  channel.sql.fromQuery("select * from test", db: "athena", emitColumns:true).view()
}
```

For more information on the implementation, please see [https://github.com/nextflow-io/nf-sqldb/discussions/5](https://github.com/nextflow-io/nf-sqldb/discussions/5).


### Repositories

**<p data-question>Q: Can Tower integrate with JFrog Artifactory?</p>**

Yes. Tower-invoked jobs have been successfully run on AWS Batch and EKS, using container images sourced from a private JFrog repository. Integration methods differ depending on your target compute environment:

- If using AWS Batch, modify your EC2 Launch Template as per [these directions from AWS](https://aws.amazon.com/blogs/compute/how-to-authenticate-private-container-registries-using-aws-batch/).<br>**Note:** 
    - This solution requires that your Docker Engine be [at least 17.07](https://docs.docker.com/engine/release-notes/17.07/) to use `--password-stdin`.
    - You may need to add the following additional commands to your Launch Template depending on your security posture:<br>
    `cp /root/.docker/config.json /home/ec2-user/.docker/config.json && chmod 777 /home/ec2-user/.docker/config.json`
- If using EKS, please consult the configuration defined here: [https://github.com/nextflow-io/nextflow/issues/2827](https://github.com/nextflow-io/nextflow/issues/2827).

### tw CLI

**<p data-question>Q: Can a custom run name be specified when launch a pipeline via the `tw` CLI?</p>**

Yes. As of `tw` v0.6.0, this is possible. Example: `tw launch --name CUSTOM_NAME ...`


### Workspaces

**<p data-question>Q: Why is my Tower-invoked pipeline trying to contact a different Workspace than the one it was launched from?</p>**

This problem will express itself with the following entry in your Nextflow log: `Unexpected response for request http://YOUR_TOWER_URL/api/trace/TRACE_ID/begin?workspaceId=WORKSPACE_ID`.

This can occur due to the following reasons:

1. An access token value has been hardcoded in the `tower.accessToken` block of your `nextflow.config` (either via the git repository itself or override value in the launch form).
2. In cases where your compute environment is an HPC cluster, the credentialized user's home directory contains a stateful `nextflow.config` with a hardcoded token (e.g. `~/.nextflow/config).


## Amazon

### EC2 Instances

**<p data-question>Q: Can I run a Nextflow head job on AWS Gravitron instances?</p>**

No. Nextflow does not yet run on ARM-based compute instances.


### ECS

**<p data-question>Q:How often are docker images pulled by the ECS Agent?</p>**

As part of the AWS Batch creation process, Tower Forge will set ECS Agent parameters in the EC2 Launch Template that is created for your cluster's EC2 instances:

* For clients using Tower Enterprise v22.01 or later:
    * Any AWS Batch environment created by Tower Forge will set the ECS Agent's `ECS_IMAGE_PULL_BEHAVIOUR` set to `once`. 
* For clients using Tower Enterprise v21.12 or earlier:
    * Any AWS Batch environment created by Tower Forge will set the ECS Agent's `ECS_IMAGE_PULL_BEHAVIOUR` set to `default`.

Please see the [AWS ECS documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html) for an in-depth explanation of this difference. 

</p>**Note:</p>** This behaviour cannot be changed within the Tower Application.


### Queues

**<p data-question>Q: Does Nextflow Tower support the use of multiple AWS Batch queues during a single job execution?</p>**

Yes. Even though you can only create/identify a single work queue during the definition of your AWS Batch Compute Environment within Nextflow Tower, you can spread tasks across multiple queues when your job is sent to Batch for execution via your pipeline configuration.

Adding the following snippet to either your _nextflow.config_ or the **Advanced Features > Nextflow config gile** field of Tower Launch UI, will cause processes to be distributed across two AWS Batch queues, depending on the assigned named.

```bash
# nextflow.config 

process {
  withName: foo {
    queue: `TowerForge-1jJRSZmHyrrCvCVEOhmL3c-work`
  }
}

process {
  withName: bar {
    queue: `custom-second-queue`
  }
}
```


### Security

**<p data-question>Q: Can Tower connect to an RDS instance using IAM credentials instead of username/password?</p>**

No. Nextflow Tower must be supplied with a username & password to connect to its associated database.


### Storage

**<p data-question>Q: Can I use EFS as my work directory?</p>**

As of Nextflow Tower v21.12, you can specify an Amazon Elastic File System instance as your Nextflow work directory when creating your AWS Batch Compute Environment via Tower Forge. 


 **<p data-question>Q: Can I use FSX for Luster as my work directory?</p>**

As of Nextflow Tower v21.12, you can specify an Amazon FSX for Lustre instance as your Nextflow work directory when creating your AWS Batch Compute Environment via Tower Forge.


**<p data-question>Q: How do I configure my Tower-invoked pipeline to be able to write to an S3 bucket that enforces AES256 server-side encryption?**

If you need to save files to an S3 bucket protected by a [bucket policy which enforces AES256 server-side encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingServerSideEncryption.html), additional configuration settings must be provided to the [nf-launcher](https://quay.io/repository/seqeralabs/nf-launcher?tab=tags) script which invokes the Nextflow head job:

1. Add the following configuration to the **Advanced options > Nextflow config file** textbox of the **Launch Pipeline** screen:
    ```
    aws {
      client {
        storageEncryption = 'AES256'
      }
    }
    ```

2. Add the following configuration to the **Advanced options > Pre-run script** textbox of the **Launch Pipeline** screen:
    ```bash
    export TOWER_AWS_SSE=AES256
    ```

**Note:** This solution requires at least Tower v21.10.4 and Nextflow [22.04.0](https://github.com/nextflow-io/nextflow/releases/tag/v22.04.0). 


## Azure

### AKS

**<p data-question>Q: Why is Nextflow returning a "... /.git/HEAD.lock: Operation not supported" error?</p>**

This problem can occur if your Nextflow pod uses an Azure Files-type (SMB) Persistent Volume as its storage medium. By default, the `jgit` library used by Nextflow attempts a filesystem link operation which [is not supported](https://docs.microsoft.com/en-us/azure/storage/files/files-smb-protocol?tabs=azure-portal#limitations) by Azure Files (SMB).

To avoid this problem, please add the following code snippet in your pipeline's **pre-run script** field:

```bash
cat <<EOT > ~/.gitconfig
[core]
	supportsatomicfilecreation = true
EOT
```

### Batch

**<p data-question>Q: Why is my Azure Batch VM quota set to 0?</p>**

In order to manage capacity during the global health pandemic, Microsoft has reduced core quotas for new Batch accounts. Depending on your region and subscription type, a newly-created account may not be entitled to any VMs without first making a service request to Azure. 

Please see Azure's [Batch service quotas and limits](https://docs.microsoft.com/en-us/azure/batch/batch-quota-limit#view-batch-quotas) page for further details. 


### SSL

**<p data-question>Q: "Problem with the SSL CA cert (path? access rights?)" error</p>**

This can occur if a tool/library in your task container requires SSL certificates to validate the identity of an external data source.

You may be able to solve the issue by:

1. Mounting host certificates into the container ([example](https://github.com/nextflow-io/nextflow/blob/v21.10.6/plugins/nf-azure/src/main/nextflow/cloud/azure/batch/AzBatchService.groovy#L348-L351)).


## Google

### Retry

**<p data-question>Q: How do I make my Nextflow pipelines more resilient to VM preemption?</p>**

Running your pipelines on preemptible VMs provides significant cost savings but increases the likelihood that a task will be interrupted before completion. It is a recommended best practice to implement a retry strategy when you encounter [exit codes](https://cloud.google.com/life-sciences/docs/troubleshooting#retrying_after_encountering_errors) that are commonly related to preemption. Example:

```config
process {
  errorStrategy = { task.exitStatus in [8,10,14] ? 'retry' : 'finish' }
  maxRetries    = 3
  maxErrors     = '-1'
}
```


## Kubernetes

**<p data-question>Q: Pod failing with 'Invalid value: "xxx": must be less or equal to memory limit' error</p>**

This error may be encountered when you specify a value in the **Head Job memory** field during the creation of a Kubernetes-type Compute Environment. 

If you receive an error that includes `field: spec.containers[x].resources.requests` and `message: Invalid value: "xxx": must be less than or equal to memory limit`, your Kubernetes cluster may be configured with [system resource limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/) which deny the Nextflow head job's resource request. To isolate which component is causing the problem, try to launch a Pod directly on your cluster via your Kubernetes administration solution. Example:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: debug
  labels:
    app: debug
spec:
  containers:
    - name: debug
      image: busybox
      command: ['sh','-c','sleep 10']
      resources:
        requests:
          memory: "xxxMi"    # or "xxxGi"
  restartPolicy: Never
```


## On-Prem HPC

**<p data-question>Q: "java: command not found"</p>**

When submitting jobs to your on-prem HPC (regardless of whether using SSH or Tower-Agent authentication), the following error may appear in your Nextflow logs even though you have Java on your $PATH environment variable:
```
java: command not found
Nextflow is trying to use the Java VM defined for the following environment variables:
  JAVA_CMD: java
  NXF_OPTS:
```

Possible reasons for this error:

1. The queue where the Nextflow head job runs in a different environment/node than your login node userspace.
2. If your HPC cluster uses modules, the Java module may not be loaded by default.

To troubleshoot:

1. Open an interactive session with the head job queue.
2. Launch the Nextflow job from the interactive session.
3. If you cluster used modules:
    1. Add `module load <your_java_module>` in the **Advanced Features > Pre-run script** field when creating your HPC Compute Environment within Nextflow Tower.
4. If you cluster does not use modules:
    1. Source an environment with java and Nextflow using the **Advanced Features > Pre-run script** field when creating your HPC Compute Environment within Nextflow Tower.
