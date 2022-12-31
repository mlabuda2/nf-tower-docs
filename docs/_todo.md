FAQ TO DOs:

# GENERAL
* $TOWER_AGENT_WORKDIR
* What does `NXF_PLUGINS_DEFAULT` environment variable do?
* Where is the analysis running?
* What about security of my data?
* Identity via LDAP/Active Directory
* Difference between free and paid Tower?
* Can I have Service-Account-type and Agent-type credentials in the same Workspace?
    * Not right now. Must choose. https://github.com/seqeralabs/nf-tower-cloud/issues/2879#issuecomment-1072646557


# Amazon
* [Can I have Nextflow automatically retry Tasks that fail due to Spot instance reclamation?](#aws_spot_retry)
* **Can I have Nextflow automatically retry Tasks that fail due to Spot instance reclamation?** <a id="aws_spot_retry"></a>

    Yes. As of Tower version ?????, any Spot-based AWS Batch Compute Environment created by Tower Forge will be automatically configured to retry each process 3 times. ??? If a retry policy is not defined???

    Given that Spots can be reclaimed during the execution of a job, it is a recommended practice that pipeline authors always include retry logic in their logic. ???See HERE for examples???
    https://github.com/seqeralabs/nf-tower-cloud/pull/2820/files



    * [Why won't Secrets work with my legacy Tower Forge-created AWS Batch Compute Environment?](aws_secrets_legacy)
    * **Why won't Secrets work with my legacy Tower Forge-created AWS Batch Compute Environment?** <a id="aws_secrets_legacy"></a>

    The Secrets feature requires new permissions to be added to existing IAM Roles:
    * The User/Role used by your Tower implementation must have the `secretsmanager:CreateSecret`.
    * Your Batch EC2 Instance Role must have ??? execution role ???
    * Added details from here: https://github.com/seqeralabs/nf-tower-cloud/pull/2820



    Add Tower Agent blurb re: Rijkzwaan as per https://git.seqera.io/rijkzwaan/nf-support/issues/15#issuecomment-8438

    Meeting summary for 31-03-2021

Adding quick summary for the meeting today, please feel free to add/correct anything I might have missed.

    With Jordi's guidance, the $TW_USER_AGENT was successfully used on an agent running in Kim's account to launch a pipeline from Daniel's user on Tower UI

    The slight nuance on the RKZ cluster was that the home directories seem to be following a non-standard pattern i.e. with all-caps usernames (for example /home/DCR) and we had to append USER=DCR tw-agent ... to enable the agent.

    An upgrade to the latest version of Tower would enable the use of $TW_AGENT_WORK variable with the agent

    We also discussed the usage of pipeline reports feature

Follow-ups

    @daniel-cruz-rijkzwaan to follow up here with an independent experiment to get up and running with tw-agent

    Abhinav to request the addition of Daniel's account in the community/showcase workspace in tower.nf

Warmly,
Abhinav





AZURE Batch - SSL problem as per https://git.seqera.io/eagle/nf-support/issues/10#issuecomment-8523


### Determine if this is relevant to Google FAQ section:
https://github.com/nf-core/configs/blob/master/conf/google.config as per this ticket: https://git.seqera.io/pluto/nf-support/issues/6

TO DO: As per Ben, document profile injection behaviour into Tower docs (e.g. nf-core automagically injecting google profile if executing on GLS)
 