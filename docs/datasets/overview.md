---
title: Datasets overview
headline: "Datasets"
description: "Managing and using datasets in Nextflow Tower."
---

## Overview

**Datasets** in Nextflow Tower are dataset files in CSV (comma-separated values) and TSV (tab-separated values) format, stored in a workspace, to be used as inputs to pipelines.

For your pipeline to use your dataset as input during runtime, information about the dataset and file format must be included in the relevant parameters of your [pipeline-schema](../pipeline-schema/overview.md).

We highly recommend using the nf-core tools [schema build](https://nf-co.re/tools/#pipeline-schema) feature to simplify the schema creation process. `schema build` commands include the option to validate and lint your schema file according to best practice guidelines from the nf-core community.

![](_images/datasets_listing.png)

!!! note
This feature is only available in [organization workspaces](../orgs-and-teams/workspace-management.md).

## Creating a new Dataset

To create a new dataset, follow these steps:

1. Open the `Datasets` tab in your organization workspace.

2. Select `New dataset`.

![](_images/create_dataset.png)

3. Complete the **Name** and **Description** fields using information relevant to your dataset.

4. Add the dataset file to your workspace with drag-and-drop or the system file explorer dialog.

5. For dataset files that use the first row for column names, customize the dataset view with the `First row as header` option.

!!! warning
The size of the dataset file cannot exceed 10MB.

## Dataset versions

**Datasets** in Tower can accommodate multiple versions of a dataset. To add a new version for an existing dataset, follow these steps:

1. Select **Edit** next to the dataset you wish to update.

2. In the Edit dialog, select **Add a new version**.

3. Upload the newer version of the dataset and select **Update**.

!!! warning
All subsequent versions of a dataset must be in the same format (`.csv` or `.tsv`) as the initial version.

## Using a Dataset

To use a dataset with the saved pipelines in your workspace, follow these steps:

1. Open any pipeline that contains a [pipeline-schema](../pipeline-schema/overview.md) from the [Launchpad](../launch/launchpad.md).

2. Select the input field for the pipeline, removing any default value.

3. Pick the dataset to use as input to your pipeline.

![](_images/datasets_dropdown.png)

!!! note
The datasets shown in the drop-down menu depend on the format specified in your [pipeline-schema](../pipeline-schema/overview.md). If the schema specifies `"mimetype": "text/csv"`, no `TSV` datasets will be available, and vice versa.
