---
title: Datasets overview
headline: "Datasets"
description: 'Managing and using datasets in Nextflow Tower.'
---

## Overview

The **Datasets** feature in Nextflow Tower allows users to store CSV and TSV formatted dataset files in a workspace, to use as an input one or more pipelines. 

In order for your pipeline to use your dataset as input during runtime, information about the dataset and file format must be included in the `input` parameters of your [pipeline-schema](/pipeline-schema/overview). We recommend using the nf-core tools [schema build](https://nf-co.re/tools/#pipeline-schema) feature to simplify the schema creation process. Commands include an option to validate and lint your schema file according to best practice guidelines from the nf-core community. 


![](_images/datasets_listing.png)

!!! note
    This feature is only available in [organization workspaces](../orgs-and-teams/workspace-management.md).



## Creating a new Dataset

To create a new dataset, follow these steps:

1. Open the `Datasets` tab in your organization workspace.

2. Select `New dataset` to open the dataset creation dialog shown below.

![](_images/create_dataset.png)

3. Complete the **Name** and **Description** fields using information relevant to your dataset.

4. You can add the dataset file to your workspace using drag-and-drop, or the system file explorer dialog.

5. You can customize views for the dataset using the `First row as header` option, for dataset files that use the first row for column names.


!!! warning
    The size of the dataset file cannot exceed 10MB.


## Dataset versions

The **Datasets** feature can accommodate multiple versions of a dataset. To add a new version for a dataset, follow these steps:

1. Select **Edit** next to the dataset you wish to update.

2. In the Edit dialog, select **Add a new version**.

3. Upload the newer version of the dataset and select **Update**.

!!! warning
    All subsequent versions of a dataset must be in the same data format as the initial version.


## Using a Dataset

To use a dataset with the saved pipelines in your workspace, follow these steps:

1. Open any pipeline that contains a [pipeline-schema](/pipeline-schema/overview) from the [Launchpad](/launch/launchpad).

2. Select the input field for the pipeline, removing any default value. 

3. Pick the desired dataset for your pipeline.


![](_images/datasets_dropdown.png)


!!! warning
    The datasets shown in the dropdown menu depend upon the validation in your [pipeline-schema](/pipeline-schema/overview). If the schema specifies only `CSV` format, no `TSV` dataset would appear in the dropdown.