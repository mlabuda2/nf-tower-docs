---
title: Runs Overview
headline: 'Monitoring Pipelines'
description: 'Guide to monitoring Nextflow pipelines executed through Tower.'
---

## Runs

Jobs that have been submitted with Tower can be monitored wherever you have an internet connection. 

The **Runs** tab contains all previous jobs executions. Each new or resumed job will be given a random name e.g: `grave_williams`.

![](_images/monitoring_overview.png)

The colors signify the completion status:

  - **Blue** are running.
  - **Green** are successfully executed.
  - **Yellow** are successfully executed where some tasks failed.
  - **Red** are jobs where at least one task fully failed.
  - **Grey** are jobs that where forced to stop during execution.

Selecting any particular run from the panel will display that runs execution details.

## Search

The search box allows searching for workflows by `project name`, `run name`, `session id` or `manifest name`. Moreover, wildcards can be used to filter the desired workflows such as using asterisks `*` before and after keyword to filter results.

![](_images/monitoring_search.png)

