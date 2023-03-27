---
title: Workspace Management
headline: "Workspace Management"
description: "Manage users and teams for an organization."
---

## Organization workspaces

**Organization workspaces** extend the functionality of a [User Workspace](../getting-started/workspace.md) and adds the ability to fine-tune the access level for any particular member, collaborator, or team. This is achieved by managing **participants** in the organization workspaces.

<!-- prettier-ignore -->
!!! note
A participant may be a **member** of the parent organization of that workspace or may be a **collaborator** only for that workspace within that organization.

### Create a new workspace

To create a new workspace within an organization:

1. Go to the **Workspaces** tab of the organization menu.
2. Select **Create workspace**.
3. Enter the **Name** and **Full name** of the workspace.
4. Optionally, add the **Description** of the workspace.
5. Click on **Open** for the newly created workspace.

<!-- prettier-ignore -->
!!!tip 
    It is possible to change the values of the optional fields either using the **Edit** option on the workspace listing for an organization or using the **Settings** tab within the workspace page, provided that you are the **Owner** of the workspace.

Apart from the **Participants** tab, the **organization workspace** is similar to the **user workspace**. Therefore, the concepts of [Runs](../launch/launch.md), [Pipeline Actions](../pipeline-actions/overview.md), [Compute Environments](../compute-envs/overview.md) and [Credentials](../credentials/overview.md) are applicable.

### Add a new Participant

To create a new Participant within an organization:

1. Go to the **Participants** tab of the organization menu.
2. Click on **Add participant**.
3. Enter the **Name** of the new participant.
4. Optionally, update the **role** associated with the participant of the organization members or collaborators. For more information on **roles**, please refer to the [participant roles](#participant-roles) section.

<!-- prettier-ignore -->
!!! tip
A new workspace participant could be either an existing organization member, collaborator, team, or a new user.

### Participant roles

Organization owners can assign a role-based access level within an organization workspace to any of the **participants** in the workspace.

<!-- prettier-ignore -->
!!! hint
It is also possible to group **members** and **collaborators** into **teams** and apply a role to that team.

There are five roles available for every workspace participant.

1. **Owner**: The participant has full permissions on any resources within the workspace, including the workspace settings.

2. **Admin**: The participant has full permissions on the resources associated with the workspace. Therefore they can create/modify/delete Pipelines, Compute environments, Actions and Credentials. They can add/remove users to the workspace, but cannot access the workspace settings.

3. **Maintain**: The participant can launch pipelines and modify pipeline executions (e.g. they can change the pipeline launch compute environments, parameters, pre/post-run scripts, and nextflow configuration) and create new pipelines in the Launchpad. The users cannot modify Compute Environments and Credentials.

4. **Launch**: The participant can launch pipelines and modify the pipeline input/output parameters in the Launchpad. They cannot modify the launch configuration or other resources.

5. **View**: The participant can view the team pipelines and runs in read-only mode.

### Sharing monitoring with workspace

To allow users executing pipelines from the command-line to share their runs with a given workspace, follow the instructions under [Getting Started](../getting-started/usage.md)
