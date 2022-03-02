---
title: Core Concepts
headline: "Definitions"
description: 'Core concepts and terms used in Tower.'
---

## Pipelines

A Pipeline is composed of a workflow repository, launch parameters, and a Compute Environment. Pipelines are used to define frequently used pre-configured workflows in a Workspace.


## Launchpad

The Launchpad contains the collection of available Pipelines that can be run in a Workspace.


## Workflow Runs

Workflow Runs are the collection executions in a Workspace. Runs displays the collection of executions in a Workspace and is used to monitor and inspect details from workflow executions.


## Datasets

Datasets are collections of versioned structured data such as TSV and CSV files. They are used for managing sample sheets and metadata. Datasets can be validated and used as inputs for workflow executions.


## Actions

Actions automate the execution of pre-configured workflows based on event triggers such as code commits and webhooks. They are used to automate workflow executions.


## Compute Environments

A Compute Environment is composed of credentials, configuration settings and storage options related to a computing platform. They are used to configure and manage computing platforms where workflows are executed.


## Credentials

Credentials are access keys stored by Tower in an encrypted manner using AES-256. They allow safe storage of authentication keys for Compute Environments, private code repositories, and external services. Credentials cannot be accessed once stored.


## Secrets

Secrets, like Credentials, are keys that may be used by pipelines in order to interact with external systems e.g. a password to connect to an external database. Secrets are stored within Tower using AES-256 encryption. Currently, there are two main types of secrets:

- Workspace-level Secrets are injected into all Pipelines that are launched within a Workspace.

- User Secrets are injected in all the pipeline launched by a specific user  

> In case of a name clash the User Secrets have higher priority and will override any Workspace Secret with the same name


## Workspace

Workspaces provide the context in which a user operates i.e. launch workflow executions and defines what resources are available/accessible and who can access/operate on those resources. They are are composed of Pipelines, Runs, Actions, Datasets, Compute Environments and Credentials. Access permissions are controlled through Participants, Collaborators and Teams.
 

## Organizations

Organizations is the top-level entity where businesses, institutions and groups can collaborate. Organizations can contain multiple Workspaces.


## Members

A user, internal to the organization. A Member has an Organization role and can operate in one or more Organisation Workspaces. In each Workspace, Members can have a Participant role that defines the permissions granted to that user within that Workspace.


## Team

A group of the Members in the same organization. A Team can operate in one more organisation workspaces with a specific Workspace role (one role per Workspace).


## Participant

A user operating with a specific Role within a Workspace


## Participant Role

The Participant Role defines the permissions granted to a user to operate within a Workspace.
