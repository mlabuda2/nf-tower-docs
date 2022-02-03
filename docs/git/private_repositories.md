---
title: Private Git repositories
headline: "Private Git repositories"
description: 'Managing and connecting to Nextflow workflows to private Git repositories using Nextflow Tower.'
---

Access to private Git repositories can be managed from the Credentials section, accessible from the **Credentials** tab.

Tower provides support to connect to private repositories from the popular Git hosting platforms GitHub, GitLab, and BitBucket.

![](_images/git_platforms.png)


!!! note 
    All credentials are securely stored using advanced encryption (AES-256) and never exposed by any Tower API.

## GitHub

To connect a private GitHub repository you need to enter a **Name** for the credentials, a **Username** and a **Password** or **Access token**. 

!!! hint 
    It is recommended to use an **access token** instead of a using your password. Personal access tokens (PATs) are an alternative to using passwords for authentication to GitHub when using APIs. Step-by-step instructions to create a personal access token can be found [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).


## GitLab

To connect a private GitLab repository you need to enter a **Name** for the credentials, a **Username**, **Password** and **Access token**.

A GitLab API access token that can be found in your [GitLab account page](https://docs.gitlab.com/ee/api/personal_access_tokens.html). Make sure to select the `api`, `read_api`, and  `read_repository` options.

![](_images/git_gitlab_access_token.png)


## Bitbucket

To connect a private BitBucket repository you need to enter a **Name** for the credentials, a **Username** and a **BitBucket App password**. 

[This step-by-step example](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/) shows how to create a BitBucket App password.

## Self-hosted Git

It is also possible to specify Git server endpoints for private hosting.

These can be specified in a file `tower.yml` and must be accessible from the backend and cron container instances.

```yaml
tower:
  scm:
    providers:
      my_org_bitbucket:
        server: "https://bitbucket.my-org.com"
        endpoint: "<API endpoint if different from the above>"
        platform: bitbucketserver
        user: some_user_name
        password: password_or_access_token

```

!!! tip 
    For more details on this configuration, see the [Nextflow SCM configuration file](https://www.nextflow.io/docs/latest/sharing.html#scm-configuration-file) for examples. You can first test your connection with a Nextflow execution using the standard SCM file and then convert it to the YAML structure, as shown above, for Tower.

