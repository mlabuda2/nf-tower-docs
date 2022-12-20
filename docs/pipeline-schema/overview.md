---
title: Pipeline Schema
headline: 'Pipeline Schema'
description: 'A brief introduction to pipeline schema.'
---

## Overview

This page provides an overview of what pipeline schema files are, why they are used, and how to build and customize your own pipeline JSON schema file.

![Tower Launch interface](_images/pipeline_schema_form.png)


## What is a pipeline schema?

Pipeline schema files describe the structure and validation constraints of your workflow parameters. They are used to validate parameters before launch to prevent software/pipelines failing in unexpected ways at runtime.

Tower uses your pipeline schema to build a bespoke launchpad parameters form.

!!! tip
    You can populate the parameters in the pipeline by uploading a YAML or a JSON file, or in the Tower UI.

See [here](https://github.com/nf-core/rnaseq/blob/e049f51f0214b2aef7624b9dd496a404a7c34d14/nextflow_schema.json) for an example of a pipeline schema file for the `nf-core/rnaseq` pipeline. 

## How can I build my own Pipeline schema file for my Nextflow pipelines?

The pipeline schema is based on [json-schema.org](https://json-schema.org/) syntax, with some additional conventions. While you can create your pipeline schema manually, we recommmend the use of [nf-core tools](https://nf-co.re/tools), a toolset for developing Nextflow pipelines.

When you run the `nf-core schema build` command in your pipeline root directory, the tool collects your pipeline parameters and gives you interactive prompts about missing or unexpected parameters. If no existing schema file is found, the tool will create one for you.

For more information, see [this link](https://nf-co.re/tools/#build-a-pipeline-schema).


## How can I customise my schema file?

Once the skeleton pipeline schema file has been built with `nf-core schema build`, the command line tool will prompt you to open a [graphical schema editor](https://nf-co.re/pipeline_schema_builder) on the nf-core website.

![nf-core schema builder interface](./_images/pipeline_schema_overview.png)

Leave the command-line tool running in the background - it checks the status of your schema on the website. When you select <kbd>Finished</kbd> on the schema editor page, it will save your changes to the schema file locally.


## Can I use the pipeline schema builder for pipelines outside of nf-core?

Yes. The schema builder is created by the nf-core community, but should work for any Nextflow pipeline.
