---
title: Google Cloud Artifact Registry credentials
headline: "Google Cloud Artifact Registry credentials"
description: "Step-by-step instructions to set up Google Cloud Artifact Registry credentials in Nextflow Tower."
---

## Registry credentials

From version 22.3, Tower supports the configuration of credentials for container registry services. These credentials are leveraged by the Nextflow Wave container service to authenticate to private container registries. For more information on Wave containers, see [here](https://www.nextflow.io/docs/latest/wave.html).

### Google Cloud Artifact Registry access

Google Cloud Artifact Registry is fully integrated with Google Cloud services and supports various authentication methods. Tower requires programmatic access to your private registry using [long-lived service account keys](https://cloud.google.com/artifact-registry/docs/docker/authentication#json-key) in JSON format.

Long-lived service account keys with elevated permissions are a potential security risk. Create dedicated service account keys that are only used to interact with your repositories — Tower requires the [Artifact Registry Reader](https://cloud.google.com/artifact-registry/docs/access-control#permissions) role.

Administrators can create a service account from the Google Cloud console:

1. Navigate to the [Create service account](https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts/create?walkthrough_id=iam--create-service-account) page.
2. Select a Cloud project.
3. Enter a service account name and (optional) description.
4. Select **Create and continue**.
5. From the **Role** drop-down menu under step 2, select **Artifact Registry -> Artifact Registry Reader**, then select Continue.
6. (Optional) Grant other users and admins access to this service account under step 3.
7. Select **Done**.
8. From the project service accounts page, select the three-dot menu button under **Actions** for the service account you just created, then select **Manage keys**.
9. On the Keys page, select **Add key**.
10. On the Create private key popup, select **JSON** and then **Create**. This triggers a download of a JSON file containing the service account private key and service account details.
11. Base-64 encode the contents of the JSON key file:

```bash

#Linux
base64 KEY-FILE-NAME > NEW-KEY-FILE-NAME

#macOS
base64 -i KEY-FILE-NAME -o NEW-KEY-FILE-NAME

#Windows
Base64.exe -e KEY-FILE-NAME > NEW-KEY-FILE-NAME

```

<!-- prettier-ignore -->
!!! note
    The base64-encoding result differs based on platform — ensure that the encoded key content does not include any line breaks

### Add credentials to Tower

- From an organization workspace: navigate to the Credentials tab and select **Add Credentials**.

- From your personal workspace: select **Your credentials** from the user avatar menu in the top right corner of the page, then select **Add credentials**.

![](_images/container_registry_credentials_blank.png)

| Property        | Description                                                                             | Example                     |
| --------------- | --------------------------------------------------------------------------------------- | --------------------------- |
| Name            | A unique name for the credentials using alphanumeric characters, dashes, or underscores | `my-registry-creds`         |
| Provider        | Credential type                                                                         | Container registry          |
| User name       | Service account key type                                                                | `_json_key_base64`          |
| Password        | Base-64 encoded JSON key file content (remove any line breaks)                          | `wewogICJ02...9tIgp9Cg==`   |
| Registry server | The container registry hostname (excluding protocol)                                    | `<location>-docker.pkg.dev` |

Once the form is complete, select **Add**. The new credential is now listed under the **Credentials** tab.

<!-- prettier-ignore -->
!!! note
    In order for your pipeline execution to leverage Wave containers, add `wave { enabled=true }` either to the **Nextflow config** field on the launch page, or to your nextflow.config file.
