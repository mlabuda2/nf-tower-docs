---
title: Container registry credentials
headline: "Container registry credentials"
description: "Step-by-step instructions to set up container registry credentials in Nextflow Tower."
---

## Introduction

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries (such as Docker Hub, Google Artifact Registry, Quay, etc.) For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

### General instructions

Using credentials, access tokens, or keys with permissions to access your registry, create container registry credentials in Tower:

- From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

- From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

![](_images/container_registry_credentials_blank.png)

| Property        | Description                                                                             | Example               |
| --------------- | --------------------------------------------------------------------------------------- | --------------------- |
| Name            | A unique name for the credentials using alphanumeric characters, dashes, or underscores | my-registry-creds     |
| Provider        | Credential provider (or credential type)                                                | Container registry    |
| User name       | Name (or access key) of a user with registry access                                     | tower_user_1          |
| Password        | Registry user password, secret key, or access token                                     | **\***                |
| Registry server | The container registry server name                                                      | docker.io/my-registry |

Once the form is complete, select **Add**. The new credential is now listed under the **Credentials** tab.

<!-- prettier-ignore -->
!!! note
    In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
