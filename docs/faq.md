---
title: Frequently Asked Questions
headline: "FAQ"
description: 'Frequestly Asked Questions'
---

## General Questions

### Administration Console

**<p data-question>Q: How do I access the Administration Console?**</p>

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

**<p data-question>Q: "Unknown pipeline repository or missing credentials" error when pulling from a public Github repository?**</p>

Github imposes [rate limits](https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting) on repository pulls (including public repositories). As of March 24, 2022, unauthenticated requests are capped at 60 requests per hour.

To fix this problem, please add a valid Github credential in your Workspace. Tower will provide this credential when making requests to the target Github repository, resulting in a higher pull cap.


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


**<p data-question>Q: "No such variable" error.**</p>

This error can occur if you execute a DSL 1-based Nextflow workflow using [Nextflow 22.03.0-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.03.0-edge) or later.


### Compute Environments

**<p data-question>Q: Can the name of a Compute Environment created in Tower contain special characters?**

No. Tower version 21.12 and later do not support the inclusion of special characters in the name of Compute Environment objects.


### Configuration

**<p data-question>Q: Can a custom path be specified for the `tower.yml` configuration file?**</p>

Yes. Provide a POSIX-compliant path to the `TOWER_CONFIG_FILE` environment variable.


**<p data-question>Q: Why do parts of `tower.yml` not seem to work when I run my Tower implementation?**</p>
    
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


**<p data-question>Q: Do you have guidance on how to create custom Nextflow containers?**</p>

Yes. Please see [https://github.com/seqeralabs/gatk4-germline-snps-indels/tree/master/containers](https://github.com/seqeralabs/gatk4-germline-snps-indels/tree/master/containers).


**<p data-question>Q: What DSL version does Nextflow Tower set as default for Nextflow head jobs?**

As of [Nextflow 22.03.0-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.03.0-edge), DSL2 is the default syntax.

To minimize disruption on existing pipelines, Nextflow Tower version 22.1.x and later are configured to default Nextflow head jobs to DSL 1 for a transition period (ending TBD).

You can force your Nextflow head job to use DSL2 syntax via any of the following techniques:

* Adding `export NXF_DEFAULT_DSL=2` in the **Advanced Features > Pre-run script** field of Tower Launch UI.
* Specifying `nextflow.enable.dsl = 2` at the top of your Nextflow workflow file.
* Providing the `-dsl2` flag when invoking the Nextflow CLI (e.g. `nextflow run ... -dsl2`)


**<p data-question>Q: Can Tower to use a Nextflow workflow stored in a local git repository?**</p>

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


### Logging

**<p data-question>Q: Can Tower enable detailed logging related to sign-in activity?**

Yes. For more detailed logging related to login events, set the following environment variable: `TOWER_SECURITY_LOGLEVEL=DEBUG`.


**<p data-question>Q: Can Tower enable detailed logging related to application activites?**

Yes. For more detailed logging related to application activities, set the following environment variable: `TOWER_LOG_LEVEL=TRACE`.


### Login

**<p data-question>Q: Can I completely disable Tower's email login feature?**</p>

The email login feature cannot be completely removed from the Tower login screen. 


**<p data-question>Q: How can I restrict Tower access to only a subset of email addresses?**</p>

You can restrict which emails are allowed to have automatic access to your Tower implementation via a configuration in _tower.yml_. 

Users without automatic access will receive an acknowledgment of their login request but be unable to access the platform until approved by a Tower administration via the Administrator Console.
```yaml
# This any email address that matches a pattern here will have automatic access.
tower:
  trustedEmails:
    - '*@seqera.io`
    - 'named_user@example.com'
```


**<p data-question>Q: Why is my OIDC redirect_url set to http instead of https?**</p>

This can occur for several reasons. Please verify the following:

1. Your `TOWER_SERVER_URL` environment variable uses the `https://` prefix.
2. Your `tower.yml` has `micronaut.ssl.enabled` set to `true`.
3. Any Load Balancer instance that sends traffic to the Tower application is configured to use HTTPS as its backend protocol rather than TCP.


**<p data-question>Q: Why isn't my OIDC callback working?**</p>

Callbacks could fail for many reasons. To more effectively investigate the problem: 

1. Set the Tower environment variable to `TOWER_SECURITY_LOGLEVEL=DEBUG`.
2. Ensure your `TOWER_OIDC_CLIENT`, `TOWER_OIDC_SECRET`, and `TOWER_OIDC_ISSUER` environment variables all match the values specified in your OIDC provider's corresponding application.
3. Ensure your network infrastructure allow necessary egress and ingress traffic.


### Miscellaneous

**<p data-question>Q: Is my data safe?**</p>

Yes, your data stays strictly within **your** infrastructure itself. When you launch a workflow through Tower, you need to connect your infrastructure (HPC/VMs/K8s) by creating the appropriate credentials and compute environment in a workspace.

Tower then uses this configuration to trigger a Nextflow workflow within your infrastructure similar to what is done via the Nextflow CLI, therefore Tower does not manipulate any data itself and no data is transferred to the infrastructure where Tower is running.




## Amazon-Specific Questions

### EC2 Instances

**<p data-question>Q: Can I run a Nextflow head job on AWS Gravitron instances?**</p>

No. Nextflow does not yet run on ARM-based compute instances.


### ECS

**<p data-question>Q:How often are docker images pulled by the ECS Agent?**</p>

As part of the AWS Batch creation process, Tower Forge will set ECS Agent parameters in the EC2 Launch Template that is created for your cluster's EC2 instances:

* For clients using Tower Enterprise v22.01 or later:
    * Any AWS Batch environment created by Tower Forge will set the ECS Agent's `ECS_IMAGE_PULL_BEHAVIOUR` set to `once`. 
* For clients using Tower Enterprise v21.12 or earlier:
    * Any AWS Batch environment created by Tower Forge will set the ECS Agent's `ECS_IMAGE_PULL_BEHAVIOUR` set to `default`.

Please see the [AWS ECS documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html) for an in-depth explanation of this difference. 

**</p>Note:**</p> This behaviour cannot be changed within the Tower Application.


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

**<p data-question>Q: Can I use EFS as my work directory?**</p>

As of Nextflow Tower v21.12, you can specify an Amazon Elastic File System instance as your Nextflow work directory when creating your AWS Batch Compute Environment via Tower Forge. 


 **<p data-question>Q: Can I use FSX for Luster as my work directory?**</p>

As of Nextflow Tower v21.12, you can specify an Amazon FSX for Lustre instance as your Nextflow work directory when creating your AWS Batch Compute Environment via Tower Forge.


## Azure

### Batch

**<p data-question>Q: Why is my Azure Batch VM quota set to 0?</p>**

In order to manage capacity during the global health pandemic, Microsoft has reduced core quotas for new Batch accounts. Depending on your region and subscription type, a newly-created account may not be entitled to any VMs without first making a service request to Azure. 

Please see Azure's [Batch service quotas and limits](https://docs.microsoft.com/en-us/azure/batch/batch-quota-limit#view-batch-quotas) page for further details. 


### SSL

**<p data-question>Q: "Problem with the SSL CA cert (path? access rights?)" error</p>**

This can occur if a tool/library in your task container requires SSL certificates to validate the identity of an external data source.

You may be able to solve the issue by:

1. Mounting host certificates into the container ([example](https://github.com/nextflow-io/nextflow/blob/v21.10.6/plugins/nf-azure/src/main/nextflow/cloud/azure/batch/AzBatchService.groovy#L348-L351)).


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
