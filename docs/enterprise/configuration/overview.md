---
layout: ../../layouts/HelpLayout.astro
title: "Tower configuration"
description: Overview of Tower configuration options
date: "21 Apr 2023"
tags: [configuration]
---

Set Tower configuration values using environment variables, a `tower.yml` configuration file, or individual values stored in AWS Parameter Store. Sensitive values (such as database passwords) should be stored securely (e.g., as SecureString type parameters in AWS Parameter Store).

=== "Environment variables"

    Declare environment variables in a [tower.env](../_templates/docker/tower.env) file:

    ```bash
    TOWER_CONTACT_EMAIL=hello@foo.com
    TOWER_SMTP_HOST=your.smtphost.com
    ``` 

    See the `Environment variables` option in each section below. 

=== "YML configuration"

    Declare YML configuration values in a [tower.yml](../_templates/docker/tower.yml) file:

    ```yml
    ...
    mail:
      from: "hello@foo.com"
      smtp:
        host: "your.smtphost.com"
    ...
    ```

    See the `tower.yml` option in each section below. YML configuration keys on this page are listed in "dot" notation, i.e., the SMTP host value in the snippet above is represented as `mail.smtp.host` in the tables that follow.  

=== "AWS Parameter Store"

    Create parameters in the AWS Parameter Store individually, using the format 
    `/config/<application_name>/<cfg_path> : <cfg_value>`: 

    ```bash
    /config/tower-app/mail.smtp.user : <your_username>
    /config/tower-app/mail.smtp.password : <your_password>
    ``` 

    Sensitive values (such as database passwords) are marked with :fontawesome-solid-triangle-exclamation: should be SecureString type parameters. See [AWS Parameter Store](./aws_parameter_store.md) for detailed instructions. 

## Basic configuration
Basic configuration options such as Tower server URL, application name, and license key. 

???+ example "Basic configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/generic_config_env.yml') }}

    === "tower.yml"
        {{ read_yaml('./configtables/generic_config_yml.yml') }}

    === "AWS Parameter Store"
        {{ read_yaml('./configtables/generic_config_aws.yml') }}


## Tower and Redis Databases

Configuration values for interacting with your database and redis instances.

As of Tower version 22.3, we officially support Redis version 6. Follow your cloud provider specifications to upgrade your instance. 

!!! warning

    If you use a database **other than** the provided `db` container, you must create a MySQL user and database schema manually.

    === "MySQL"

        ```SQL
        CREATE DATABASE tower;
        ALTER DATABASE tower CHARACTER SET utf8 COLLATE utf8_bin;

        CREATE USER 'tower' IDENTIFIED BY <password>;
        GRANT ALL PRIVILEGES ON tower.* TO tower@'%' ;
        ```

    === "MariaDB"

        ```SQL
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER on tower.* TO tower@'%';
        ```

???+ example "Database and Redis configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/db_env.yml') }}

    === "tower.yml"
        {{ read_yaml('./configtables/db_yml.yml') }}    

    === "AWS Parameter Store"
        {{ read_yaml('./configtables/db_aws.yml') }}      


## Cryptographic options
Configuration values for how Tower secures your data.

!!! warning
    Do not modify the Tower crypto secret key between starts! Changing this value will preclude decryption of existing data.

???+ example "Cryptographic configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/crypto_env.yml') }}

    === "tower.yml"
        {{ read_yaml('./configtables/crypto_yml.yml') }}

    === "AWS Parameter Store"
        {{ read_yaml('./configtables/crypto_aws.yml') }} 


## Compute environments
Configuration values for controlling how Tower presents and Tower Forge names generated resources.

???+ example "Compute environment configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/compute_env.yml') }}


## Git integration
Nextflow Tower has built-in support for public and private Git repositories. Create [Git provider credentials](https://help.tower.nf/23.1/git/overview/) to allow Tower to interact with the following services: 

- [GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [BitBucket]( https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html)
- [GitLab](https://gitlab.com/profile/personal_access_tokens)
- [Gitea](https://docs.gitea.io/en-us/development/api-usage/#generating-and-listing-api-tokens) 
- [Azure Repos](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

!!! warning
    Credentials configured in your Tower SCM providers list may override Git credentials in your (organization or personal) workspace. Be careful if you populate values via both methods.

    Public Git repositories can be accessed without authentication, but are often subject to [throttling](https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#rate-limits-for-requests-from-personal-accounts). We recommend always adding Git credentials to your Tower workspace regardless of the repository type you will use.



???+ example "Git configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/git_env.yml') }}

    === "tower.yml"
        {{ read_yaml('./configtables/git_yml.yml') }}

    === "AWS Parameter Store"
    
        {{ read_yaml('./configtables/git_aws.yml') }}


## Mail server

Configure values for SMTP service interaction.

???+ example "Mail server configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/mail_server_env.yml') }}

    === "tower.yml"
        {{ read_yaml('./configtables/mail_server_yml.yml') }}

    === "AWS Parameter Store"
        {{ read_yaml('./configtables/mail_server_aws.yml') }}


#### Proxy Server (optional)

??? example "Proxy Server configuration options"
    {{ read_yaml('./configtables/mail_server_proxy.yml') }}


## Nextflow launch container

!!! warning
    Seqera Labs recommends not replacing the [Tower-provided default image](https://help.tower.nf/latest/functionality_matrix/functionality_matrix/) unless absolutely necessary.


???+ example "Nextflow launch container configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/nf_launch.yml') }} 


## Tower API
Enable the API endpoints to host the Tower OpenAPI specification and use the [Tower CLI](https://github.com/seqeralabs/tower-cli).


???+ example "Tower API configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/api.yml') }}


## Tower custom navigation menu

Modify your Tower instance's navigation menu options.

???+ example "Tower custom navigation menu configuration options"

    === "tower.yml"
    ```yaml
    tower:
      navbar:
        menus:
          - label: "My Community"
            url: "https://host.com/foo"
          - label: "My Pipelines"
            url: "https://other.com/bar"
    ```


## Logging

Customize the format of emitted log messages. 

???+ example "Tower logging configuration options"

    === "Environment variables"
        {{ read_yaml('./configtables/tower_logging.yml') }}
