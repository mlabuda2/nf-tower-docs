---
description: 'Managing and connecting to Git repositories for Nextflow in Nextflow Tower.'
---

Data pipelines can be composed of many assets (pipeline scripts, configuration files, dependency descriptors such as for Conda or Docker, documentation, etc). By managing complex data pipelines as Git repositories, all assets can be versioned and deployed with a specific tag, release or commit id. Version control, combined with containerization, is crucial for **enabling reproducible pipeline executions**, and it provides the ability to continuously test and validate pipelines as the code evolves over time.

Nextflow has built-in support for [Git](https://git-scm.com) and several Git-hosting platforms. Nextflow pipelines can be pulled remotely from both public and private Git-hosting providers, including the most popular platforms: GitHub, GitLab, BitBucket and Gitea.


## Public repositories

You can use a publicly hosted Nextflow pipeline by specifying the Git repository URL in the **Pipeline to launch** field. 

When specifying the **Revision number**, the list of available revisions are automatically pulled using the Git provider's API. By default, the default branch (usually `main` or `master`) will be used.

!!! tip 
    [nf-core](https://nf-co.re/pipelines) is a great resource for public Nextflow pipelines.

!!! warning "API Rate Limits"
    The GitHub API imposes [rate limits](https://docs.github.com/en/developers/apps/building-github-apps/rate-limits-for-github-apps) on API requests. You can increase your rate limit by adding GitHub credentials to your workspace.


## Private repositories

In order to access private Nextflow pipelines, you must add credentials for your private Git hosting provider.

![](_images/git_platforms.png)

!!! note 
    All credentials are securely stored using advanced encryption (AES-256) and are never exposed by any Tower API.

### GitHub

To connect a private GitHub repository, enter a **Name** for the credentials, a **Username** and a **Password** or **Access token**. 

It is recommended to use an access token instead of your password. Personal access tokens (PATs) are an alternative to using passwords for authentication to GitHub when using APIs. Step-by-step instructions to create a personal access token can be found [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).

### GitLab

To connect a private GitLab repository, enter a **Name** for the credentials, a **Username**, **Password** and **Access token**.

GitLab API access tokens can be managed from your [GitLab account page](https://docs.gitlab.com/ee/api/personal_access_tokens.html). Make sure to select the `api`, `read_api`, and  `read_repository` options.

![](_images/git_gitlab_access_token.png)

### Bitbucket

To connect a private BitBucket repository, enter a **Name** for the credentials, a **Username** and a **BitBucket App password**. 

[This step-by-step example](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/) shows how to create a BitBucket App password.

### Self-hosted Git

It is also possible to specify Git server endpoints for Tower Enterprise. For more information, refer to the [Tower Install Documentation](https://install.tower.nf/latest/configuration/git_integration/).
