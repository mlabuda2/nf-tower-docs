---
title: Quay container registry credentials
headline: "Quay container registry credentials"
description: "Step-by-step instructions to set up Quay container credentials in Nextflow Tower."
---

## Container registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

### Quay repository access

For Quay repositories, we recommend using [robot accounts](https://docs.quay.io/glossary/robot-accounts.html) for authentication:

1. Sign in to [quay.io](https://quay.io/).
2. From the user or organization view, select the **Robot Accounts** tab.
3. Select **Create Robot Account**.
4. Enter a robot account name. The username for robot accounts have the format `namespace+accountname`, where `namespace` is the user or organization name and `accountname` is your chosen robot account name.
5. Retrieve the token value by selecting the robot account in your admin panel.

### Add credentials to Tower

- From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

- From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

![](_images/container_registry_credentials_blank.png)

| Property        | Description                                                                             | Example                      |
| --------------- | --------------------------------------------------------------------------------------- | ---------------------------- |
| Name            | A unique name for the credentials using alphanumeric characters, dashes, or underscores | `my-registry-creds`          |
| Provider        | Credential type                                                                         | Container registry           |
| User name       | Robot account username (`namespace+accountname`)                                        | `mycompany+myrobotaccount`   |
| Password        | Robot account access token                                                              | `PasswordFromQuayAdminPanel` |
| Registry server | The container registry hostname                                                         | `quay.io`                    |

Once the form is complete, select **Add**. The new credential is now listed under the **Credentials** tab.

<!-- prettier-ignore -->
!!! note
    In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
