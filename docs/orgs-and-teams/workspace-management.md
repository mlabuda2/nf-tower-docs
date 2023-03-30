---
title: Workspace management
headline: "Workspace management"
description: "Manage users and teams for an organization."
---

## Overview

**Organization workspaces** extend the functionality of [user workspaces](../getting-started/workspace.md) and add the ability to fine-tune the access level for any particular member, collaborator, or team. This is achieved by managing **participants** in the organization workspaces.

Organizations have members, whereas workspaces have participants.

<!-- prettier-ignore -->
!!! note
    A workspace participant may be a **member** of the workspace organization, or a **collaborator** in that workspace alone. Collaborators count toward the workspace participants total. See [Usage limits](/docs/limits/limits.md).

### Create a new workspace

Organization owners and admins can create a new workspace in an organization:

1. Go to the **Workspaces** tab of the organization menu.
2. Select **Add Workspace**.
3. Enter the **Name** and **Full name** of the workspace.
4. Optionally, add the **Description** of the workspace.
5. Under **Visibility**, select either **Private** or **Shared**. Private visibility means that workspace pipelines are only accessible to workspace participants.
6. Select **Add**.

<!-- prettier-ignore -->
!!! tip
    Optional workspace fields can be changed after workspace creation, either by using the **Edit** option on the workspace listing for an organization or using the **Settings** tab within the workspace page, provided that you are the **Owner** of the workspace.

Apart from the **Participants** tab, the organization workspace is similar to the **user workspace**. Therefore, [runs](../launch/launch.md), [pipeline actions](../pipeline-actions/overview.md), [compute environments](../compute-envs/overview.md) and [credentials](../credentials/overview.md) apply.

### Add a new participant

To create a new participant within a workspace:

1. Go to the **Participants** tab of the workspace menu.
2. Click on **Add participant**.
3. Enter the **Name** of the new participant.
4. Optionally, update the **role** associated with the participant of the organization members or collaborators. For more information on **roles**, please refer to the [participant roles](#participant-roles) section.

<!-- prettier-ignore -->
!!! tip
    A new workspace participant could be an existing organization member, team, or collaborator.

### Participant roles

Organization owners can assign a role-based access level within an organization workspace to any of the **participants** in the workspace.

<!-- prettier-ignore -->
!!! hint
    It is also possible to group **members** and **collaborators** into **teams** and apply a role to that team. Members and collaborators inherit the access permissions of the team.

There are five roles available for every workspace participant.

1. **Owner**: The participant has full permissions on any resources within the workspace, including the workspace settings.

2. **Admin**: The participant has full permissions on the resources associated with the workspace. They can create/modify/delete pipelines, compute environments, actions and credentials. They can add/remove users to the workspace, but cannot access the workspace settings.

3. **Maintain**: The participant can launch pipelines and modify pipeline executions (e.g. they can change the pipeline launch compute environments, parameters, pre/post-run scripts, and Nextflow configuration) and create new pipelines in the Launchpad. Users with maintain permissions cannot modify compute environments and credentials.

4. **Launch**: The participant can launch pipelines and modify the pipeline input/output parameters in the Launchpad. They cannot modify the launch configuration or other resources.

5. **View**: The participant can view the team pipelines and runs in read-only mode.

### Workspace run monitoring

To allow users executing pipelines from the command-line to share their runs with a given workspace, see [Getting started](../getting-started/usage.md).
