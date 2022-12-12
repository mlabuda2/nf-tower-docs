---
title: Pipeline Schema
headline: 'Pipeline Schema'
description: 'A brief introduction to Pipeline Schema.'
---

## Overview

This page will give you a detailed description of what pipeline schema files are, why they are used, and show you how to build and customize your own Pipeline JSON schema file.

![Tower Launch interface](_images/pipeline_schema_form.png)


## What is a Pipeline schema?

Pipeline schema files describe the structure and validation constraints of your workflow parameters. They are used to validate parameters before launch to prevent software/pipelines failing in unexpected ways at runtime.

Tower uses pipeline schema to build the launchpad parameters form.

!!! tip
    You can populate the parameters in the pipeline, by uploading a YAML or a JSON file, in addition to filling it on the UI itself.


## How can I build my own Pipeline schema file for my Nextflow pipelines?

The pipeline schema is based on [json-schema.org](https://json-schema.org/) syntax, with some additional conventions. This can get complex, so we do not recommend creating or editing this file manually.

Instead, we recommmend using tools from the [nf-core](https://nf-co.re/) project, which provides a toolset for developing Nextflow pipelines.

Running the `nf-core schema build` command in your pipeline root directory collects your pipeline parameters and gives you interactive prompts about missing or unexpected parameters. If no existing schema file is found, it will create one for you.

For more information, please follow [this link](https://nf-co.re/tools/#build-a-pipeline-schema).


## How can I customise my schema file?

Once the skeleton pipeline schema file has been built with the `nf-core schema build`, the command line tool will prompt you to open a [graphical schema editor](https://nf-co.re/pipeline_schema_builder) on the nf-core website.

![nf-core schema builder interface](./_images/pipeline_schema_overview.png)

Leave the command-line tool running in the background - it checks the status of your schema on the website. When you click <kbd>Finished</kbd> on the website, it will automatically save your changes to the file locally.


## Can I use the pipeline schema builder for pipelines outside of nf-core?

Yes. The schema builder is created by the nf-core community, but should work for any Nextflow pipeline.
