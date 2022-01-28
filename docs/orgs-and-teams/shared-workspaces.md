---
title: Shared workspaces
headline: 'Shared workspace'
description: 'Create and manage shared workspaces and resources in an organization.'
---

# Overview

We introduced the concept of shared workspaces as a solution to synchronisation and resource sharing within an organisation in Tower.

With a shared workspace it is now possible to create and setup pipelines in one single place (i.e. the shared workspace) which will become accessible to all members of an organisation to be used.

The benefits that a shared workspace brings to an organisation are:
Define once and share everywhere: The shared resources need only to be setup once and then they are automatically shared across the organisation.  

Centralise the management of key resources: Organisation administrator who need to ensure that the right pipeline configuration is used in all areas of an organisation no longer need to copy and replicate a pipeline across multiple workspaces. 

Immediate updates adoption: updating parameters for a shared pipeline are immediately available everywhere across the organisations, reducing the risk of partial updates across an organisation.

Computational resource provision: shared pipelines in shared workflows can be shared together with the needed computational resources, avoiding the need to duplicate resource setup in each single workspace across the organisation. 
Shared workspaces can be used to centralise and simplify the resource sharing across an organisation in Tower


## How to create a shared workspace?

Creating a shared workspace is similar to the creation of a private workspace, with the difference of *Visibility* option, which is set to _Public_.


[ Screenshot creating a shared workspace]



## Creating a shared pipeline

To create a pipeline within a shared workspace, the choice of an associated compute environment is optional. In case, a compute environment is associated with the pipeline it will be available to users in other workspace who can launch that shared pipeline on the associate compute environment.





[ Screenshot for none compute environment]

## Shared pipelines (w/o compute environment)


## Make shared pipelines visible in a private workspace

To make a shared pipeline visible from any shared workspace, you can use the visibility option on the Launchpad.

[ Screenshot for shared pipelines visibility ]


!!! note
All or nothing 