---
title: Launchpad
headline: "Launchpad"
description: "Curate and launch workflows"
---

## Overview

**Launchpad** makes it easy for any workspace user to launch a pre-configured pipeline. Use the **Sort by:** drop-down to sort pipelines, either by name or most-recently updated. 

The list layout is the default Launchpad view. Use the toggle next to the Add pipeline button to switch between the list and tile views. Both views display the compute environment of each pipeline for easy reference.

![](../_images/overview_image.jpg)

A pipeline is a repository containing a Nextflow workflow, a compute environment, and pipeline parameters.

### Pipeline Parameters Form

Launchpad automatically detects the presence of a `nextflow_schema.json` in the root of the repository and dynamically creates a form where users can easily update the parameters.

<!-- prettier-ignore -->
!!! tip
    The parameter forms view will appear if the workflow has a Nextflow schema file for the parameters. See [**Nextflow Schema**](../pipeline-schema/overview.md) to learn more about the use cases and how to create them.

This makes it trivial for users without any expertise in Nextflow to enter their pipeline parameters and launch.

![](_images/launch_rnaseq_nextflow_schema.png)

### Adding a New Pipeline

Adding a pipeline to the workspace launchpad is similar to [launching](../launch/launch.md) a pipeline. Instead of launching the pipeline, it gets added to the list of pipelines with pre-saved values, such as the pipeline parameters and revision number.

<!-- prettier-ignore -->
!!! tip 
    To create your own customized Nextflow Schema for your pipeline, see the `nf-core` workflows that have adopted this.  [nf-core/eager](https://github.com/nf-core/eager/blob/2.3.3/nextflow_schema.json) and [nf-core/rnaseq](https://github.com/nf-core/rnaseq/blob/3.0/nextflow_schema.json) are excellent examples.
