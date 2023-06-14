---
layout: ../../layouts/HelpLayout.astro
title: "AWS Parameter Store configuration"
description: Configure SecureString values for Tower configuration using AWS Paramater Store
date: "21 Apr 2023"
tags: [configuration, aws, parameter, securestring]
---

From Tower version 23.1, Tower can fetch configuration values from the AWS Parameter Store.

## Configure Tower to use AWS Parameter Store values

To let Tower use AWS Parameter Store values:

1. Grant [AWS Parameter Store permissions](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-access.html) to your Tower host instance. 
2. Add `TOWER_ENABLE_AWS_SSM=true` in the `tower.env` configuration file.
3. Create individual parameters in the AWS Parameter Store ([see below](#create-configuration-values-in-aws-parameter-store)).
4. Start your Tower instance and confirm the following entries appear in the **backend** container log:

    ```bash
    [main] - INFO  i.m.context.DefaultBeanContext - Reading bootstrap environment configuration
    [main] - INFO  i.m.d.c.c.DistributedPropertySourceLocator - Resolved 2 configuration sources from client: compositeConfigurationClient(AWS Parameter Store)
    ```


## Create configuration values in AWS Parameter Store

Store Tower configuration values as individual parameters in the AWS Parameter Store. Values must be namespaced to avoid collisions if multiple Tower intances exist in the same AWS Account (e.g., Dev / Staging / Prod). Tower uses `tower-app` by default, but this can be modified via the `tower.application.name` key in the `tower.yml` file. 

We recommend storing sensitive values (such as database password) as SecureString-type parameters. These parameters require additional IAM KMS key permissions to be decrypted.
    
Tower does not support StringList parameters. Configuration parameters with multiple values can be created as comma-separated lists of String type.

???+ example "Create parameters in AWS Parameter Store"

    1. Navigate to the **Parameter Store** from the **AWS Systems Manager Service** console.
    2. From the **My parameters** tab, select **Create parameter** and populate as follows:

        | Field | Description |
        | ----- | ----------- |
        | **Name** | Use the format `/config/<application_name>/<cfg_path>`. `<cfg_path>` follows the `tower.yml` nesting hierarchy. See the [configuration overview](./overview.md) for specific paths.<br/>**Example: `/config/tower-app/mail.smtp.password : <your_smtp_password>`** |
        | **Description** | (Optional) Description for the parameter. |
        | **Tier** | Select **Standard**. | 
        | **Type** | Use **SecureString** for sensitive values like passwords and tokens. Use **String** for everything else. |
        | **Data type** | Select **text**. | 
        | **Value** | Enter a plain text value (this is the configuration value used by Tower). | 

