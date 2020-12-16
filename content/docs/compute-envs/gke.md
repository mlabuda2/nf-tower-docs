  ---
title: Google GKE
weight: 1
layout: single
publishdate: 2020-10-20 04:00:00 +0000
authors:
  - "Jordi Deu-Pons"
  - "Paolo Di Tommaso"
  - "Alain Coletta"
  - "Seqera Labs"

headline: 'Google GKE Compute environments'
description: 'Step-by-step instructions to set up a Tower compute environment for Google GKE cluster'
menu:
  docs:
    parent: Compute Environments
    weight: 6

---
## Overview

Google GKE is managed Kubernetes cluster that allows to run containerised workloads in the
Google cloud at scale.

Nextflow Tower has a native support for Google GKE cluster and streamline the deployment
of Nextflow pipelines in such environment.


## Requirement

You need to have GKE cluster up and running. Make sure you have followed
the steps in the [Cluster preparation] guide to create the cluster resources required
by Nextflow Tower.


## Compute environment setup  

**1.** In the navigation bar on the upper right, choose your account name then choose **Compute environments** and select **New Environment**.

{{% pretty_screenshot img="/uploads/2020/09/aws_new_env.png" %}}

</br>

**2.** Enter a descriptive name for this environment. For example, *Goole GKE* and select **Google GKE** as the target platform.

{{% pretty_screenshot img="/uploads/2020/12/gke_new_env.png" %}}

**3.** Select your Google Cloud credentials.

**4.** Enter the region where the Kubernetes cluster is located.

{{% warning "Zonal and regional clusters" %}}
In google clusters can be regional or zonal, For example, the us-west1 region the west coast of the United States has three zones: us-west1-a, us-west1-b, and us-west1-c.

Tower self-completion only shows regions. You can manually edit this field if your cluster is in a zone.

{{% /warning %}}

{{% pretty_screenshot img="/uploads/2020/12/gke_regions.png" %}}

Google regions

{{% pretty_screenshot img="/uploads/2020/12/gke_zone.png" %}}

Manually edited Google zone

**5** Enter the **namespace** e.g `tower-nf` like the [examples](#namespace-creation) above.

**6** Enter the **head service account** e.g `tower-launcher-sa` as was set as the [role and service account examples](#service-account-role-creation) above.

**7** Enter the **storage claim** e.g `tower-scratch` as was set in the [storage configuration](#gke-storage-configuration).

{{% pretty_screenshot img="/uploads/2020/12/gke_env_setup.png" %}}

## Staging options

<br>

{{% pretty_screenshot img="/uploads/2020/12/staging_options.png" %}}

You can include pre & post-run scripts to your environment. This custom code will run either before and after the execution of a Nextflow script. You can also set these at runtime when launching a pipeline.

## Advanced options

<br>

{{% pretty_screenshot img="/uploads/2020/12/advanced_options.png" %}}

To match your cluster setup, these options allow you to customize the following default parameters:

**1.** the **storage mount path** which is by default `/scratch`

**2.** you can specify a default **work directory** where Nextflow will output results. Nextflow uses `$PWD/work` by default.  

**3.** You can edit the **Compute service account** field if the cluster has a specific **service account** setup to be used by Nextflow to execute jobs.
