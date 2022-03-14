---
title: Reports Overview
headline: 'Reports'
description: 'Overview of the Tower pipeline Reports feature.'
---

## Overview

Most Nextflow pipelines will generate reports or output files which are useful to inspect at the end of the pipeline execution. Reports may be in various formats (e.g. HTML, PDF, TXT) and would typically contain quality control (QC) metrics that would be important to assess the integrity of the results. Tower has a Reports feature that allows you to directly visualise supported file types or to download them directly via the user interface (see [Limitations](#limitations)). This saves users the time and effort from having to retrieve and visualise output files from their local storage.
## Visualising Reports

If available, Reports will be displayed in a separate tab within the Runs page for a given pipeline execution. By clicking on the drop-down box in the Reports tab, users can select the appropriate report and either visualise or download them (see [Limitations](#limitations) for supported file types).

![](_images/reports_rendering.png)

## Providing Reports

In order to render the Reports tab in the Tower UI, users will need to create a Tower config file that defines the paths to a selection of output files published by the pipeline. There a 2 ways you can provide the Tower config file both of which have to be in YAML format:

1. **Pipeline repository**: If a file called *tower.yml* exists in the root of the pipeline repository then this will be fetched automatically before the pipeline execution.,
2. **Tower UI**: Providing the YAML definition within the *Advanced options > Tower config file* box when:
  1.Creating a Pipeline in the Launchpad
  2.Amending the Launch settings when launching a Pipeline. Users with *Maintain* role only.

!!! warning 
    Any configuration provided in the Tower UI will completely override that which is supplied via the pipeline repository.

![](_images/reports_config_box.png)

## Reports implementation

Pipeline Reports need to be specified via YAML syntax

``` yaml
reports:
    <path pattern>:
        display: text to display (required)
        mimeType: file mime type (optional) 
```
### Path pattern
Only the published files (using the Nextflow `publishDir` directive) are possible report candidates files. The *path pattern* is used to match published files to a report entry. It can be a partial path, a glob expression or just a file name. 

Examples of valid *path patterns* are: 

- `multiqc.html`: This will match all the published files with this name.
- `**/multiqc.html`: This is a glob expression that matches any subfolder. It is equivalent to the previous expression.
- `results/output.txt`: This will match all the `output.txt` files inside any *results* folder. 
- `*_output.tsv`: This will match any file that ends with “_output.tsv”

!!! warning
    When you use `*` it is important to also use double quotes, otherwise it is not a valid YAML.

### Display
Display defines the title that will be shown on the website. If there are multiple files that match the same pattern an automatic suffix will be added.
The suffix is the minimum difference between all the matching paths. For example given this report definition:

``` yaml
reports:
    "**/out/sheet.tsv":
        display: "Data sheet"
```

If you have these two paths `/workdir/sample1/out/sheet.tsv` and `/workdir/sample2/out/sheet.tsv` both of them will match the path pattern and their final display name will be *Data sheet (sample1)* and *Data sheet (sample2)*.

### mimeType
By default the mime type is deduced from the file extension, so in general you don’t need to explicitly define it. Optionally, you can define it to force a viewer, for example showing a `txt` file as a `tsv`. It is important that it is a valid mime type text, otherwise it will be ignored and the extension will be used instead.

## Limitations

The current reports implementation limits the rendering to the following formats (html, csv, tsv, pdf, and txt). 
In-page rendering is restricted to files smaller than 10MB to reduce the UI overload. Larger files need to be downloaded first.
Currently, there is a YAML formatting validation in place checking both the `tower.yml` file inside the repository, and the UI configuration box. The validation phase will emit an error message when users try to launch a pipeline with non-compliant YAML definitions.
