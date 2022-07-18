---
description: 'Managing and connecting to Git repositories for Nextflow in Nextflow Tower.'
---

Data pipelines can be composed of many assets (pipeline scripts, configuration files, dependency descriptors such as for Conda or Docker, documentation, etc). By managing complex data pipelines as Git repositories, all assets can be versioned and deployed with a specific tag, release or commit id. Version control, combined with containerization, is crucial for **enabling reproducible pipeline executions**, and it provides the ability to continuously test and validate pipelines as the code evolves over time.

Nextflow has built-in support for [Git](https://git-scm.com) and several Git-hosting platforms. Nextflow pipelines can be pulled remotely from both public and private Git-hosting providers, including the most popular platforms: GitHub, GitLab, BitBucket and Gitea.


## Public repositories

You can use a publicly hosted Nextflow pipeline by specifying the Git repository URL in the **Pipeline to launch** field. 

When specifying the **Revision number**, the list of available revisions are automatically pulled using the Git provider's API. By default, the default branch (usually `main` or `master`) will be used.

![](_images/git_public_repo.png)

!!! tip 
    [nf-core](https://nf-co.re/pipelines) is a great resource for public Nextflow pipelines.

!!! warning "API Rate Limits"
    The GitHub API imposes [rate limits](https://docs.github.com/en/developers/apps/building-github-apps/rate-limits-for-github-apps) on API requests. You can increase your rate limit by adding [GitHub credentials](#github) to your workspace as shown below.


## Private repositories

In order to access private Nextflow pipelines, you must add credentials for your private Git hosting provider.

!!! note 
    All credentials are securely stored using advanced encryption (AES-256) and are never exposed by any Tower API.

### GitHub

To connect a private [GitHub](https://github.com/) repository:

1. Navigate to the **Credentials** tab, or select **Your credentials** from the navbar if you are using your personal workspace.

2. Select **Add Credentials**.

3. Enter a **Name** for the new credentials.

4. Select "GitHub" as the **Provider**.

5. Enter your **Username** and **Access token**. Refer to the [GitHub documentation](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) to learn how to create a GitHub personal access token (PAT).

6. Enter the **Repository base URL** for which the credentials should be applied (optional). This option can be used to apply the provided credentials to a specific repository, e.g. `https://github.com/seqeralabs`.

### GitLab

To connect to a private [GitLab](https://gitlab.com/) repository:

1. Navigate to the **Credentials** tab, or select **Your credentials** from the navbar if you are using your personal workspace.

2. Select **Add Credentials**.

3. Enter a **Name** for the new credentials.

4. Select "GitLab" as the **Provider**.

5. Enter your **Username**, **Password**, and **Access token**. Refer to the [GitLab documentation](https://docs.gitlab.com/ee/api/personal_access_tokens.html) to learn how to create an access token. Your access token should at least have the `api`, `read_api`, and  `read_repository` scopes in order to work with Tower.

6. Enter the **Repository base URL** for which the credentials should be applied (optional). This option can be used to apply the provided credentials to a specific repository, e.g. `https://gitlab.com/seqeralabs`.

### Bitbucket

To connect to a private [BitBucket](https://bitbucket.org/) repository: 

1. Navigate to the **Credentials** tab, or select **Your credentials** from the navbar if you are using your personal workspace.

2. Select **Add Credentials**.

3. Enter a **Name** for the new credentials.

4. Select "BitBucket" as the **Provider**.

5. Enter your **Username** and **Password**. Refer to the [BitBucket documentation](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/) to learn how to create a BitBucket App password.

6. Enter the **Repository base URL** for which the credentials should be applied (optional). This option can be used to apply the provided credentials to a specific repository, e.g. `https://bitbucket.org/seqeralabs`.

### AWS CodeCommit

To connect to a private [AWS CodeCommit](https://aws.amazon.com/codecommit/) repository:

1. Navigate to the **Credentials** tab, or select **Your credentials** from the navbar if you are using your personal workspace.

2. Select **Add Credentials**.

3. Enter a **Name** for the new credentials.

4. Select "CodeCommit" as the **Provider**.

5. Enter the **Access key** and **Secret key** of the AWS IAM account that will be used to access the desired CodeCommit repository. Refer to the [AWS documentation](https://docs.aws.amazon.com/codecommit/latest/userguide/auth-and-access-control-iam-identity-based-access-control.html) to learn more about IAM permissions for CodeCommit.

6. Enter the **Repository base URL** for which the credentials should be applied (optional). This option can be used to apply the provided credentials to a specific region, e.g. `https://git-codecommit.eu-west-1.amazonaws.com`.

### Self-hosted Git

It is also possible to specify Git server endpoints for Tower Enterprise. For more information, refer to the [Tower Install Documentation](https://install.tower.nf/latest/configuration/git_integration/).
