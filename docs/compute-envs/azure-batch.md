---
title: Azure Batch
headline: 'Azure Batch Compute Environment'
description: 'Step-by-step instructions to set up Azure Batch in Nextflow Tower.'
---
## Overview

!!! warning
    The Tower support for Azure Batch is currently in beta. Any feedback and suggestions are welcome.

    In order to manage capacity during the global health pandemic, Microsoft has reduced core quotas for new Batch accounts. Depending on your region and subscription type, a newly-created account may not be entitled to any VMs without first making a service request to Azure. 

    Please see Azure's [Batch service quotas and limits](https://docs.microsoft.com/en-us/azure/batch/batch-quota-limit#view-batch-quotas) page for further details.

!!! note "Disclaimer" 
    This guide assumes you have an existing [Azure Account](https://azure.microsoft.com/en-us). Sign up for a free Azure account [here](https://azure.microsoft.com/en-us/free/).

There are two ways to create a **Compute Environment** for **Azure Batch** with Tower.

1. **Tower Forge**: This option allows for Azure Batch to automatically create Azure Batch resources in your Azure account.

2. **Tower Launch**: This allows you to create a compute environment using existing Azure Batch resources.

If you don't yet have an Azure Batch environment fully set up, it is suggested that you follow the [Tower Forge](#forge) guide. 

If you have been provided with an Azure Batch queue from your account administrator or if you have set up Azure Batch previously, directly follow the [Tower Launch](#launch) guide.

## Forge

!!! warning 
    Follow these instructions if you have not pre-configured an Azure Batch environment. Note that this will create resources in your Azure account that you may be charged for by Azure.

### Resource group

To create the necessary Azure Batch and Azure Storage accounts, we must first create a **Resource Group** in the region of your choice.

When you open [this link](https://portal.azure.com/#create/Microsoft.ResourceGroup), you'll notice the **Create new resource group** dialogue as shown below.

![](_images/azure_new_resource_group.png) 

**1.** Add the name for the resource group (e.g. `towerrg`). 

**2.** Select the preferred region for this resource group. 

**3.** Click **Review and Create** to proceed to the review screen.

**4.** Click **Create** to create the resources.


### Storage account

The next step is to create the necessary Azure Storage. 

When you open [this link](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Storage%2FStorageAccounts), you'll notice the **Create a storage account** dialogue as shown below.

![](_images/azure_create_storage_account.png) 


**1.** Add the name for the storage account (for e.g. `towerrgstorage`).

**2.** Select the preferred region for this resource group.

**3.** Click **Review and Create** to proceed to the review screen.

**4.** Click **Create** to create the Azure Storage account.

**5.** Next, create a Blob container within this storage account by navigating to your new storage account and clicking on **Container** as shown below.


![](_images/azure_new_container.png) 

**6.** Create a new Blob container by clicking on the **+ Container** option.

A new container dialogue will open as shown below. Choose a suitable name (e.g. `towerrgstorage-container`).

![](_images/azure_create_blob_container.png) 

**7.** Once the new Blob container is created, navigate to the **Access Keys** section of the storage account (e.g. `towerrgstorage`).

**8.** Store the access keys for the newly created Azure Storage account as is pictured underneath.

![](_images/azure_storage_keys.png) 

### Batch account

The next step is to create the necessary Azure Storage. 

When you open [this link](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Batch%2FbatchAccounts), you'll notice the **Create a batch account** dialogue, as shown below.

![](_images/azure_new_batch_account.png) 

**1.** Add the name for the storage account (for e.g. `towerrgbatch`).

**2.** Select the preferred region for this resource group.

**3.** Click **Review and Create** to proceed to the review screen.

**4.** Click **Create** to create the Azure Batch account.


!!! note "Congratulations!" 
    You have completed the Azure environment setup for Tower.

### Forge compute environment

Tower Forge automates the configuration of an [Azure Batch](https://azure.microsoft.com/en-us/services/batch/) compute environment and queues required for the deployment of Nextflow pipelines.

Once the Azure resource setup is done, we can add a new **Azure Batch** environment in the Tower UI. 

To create a new compute environment, follow these steps:

**1.** In a workspace choose **Compute environments** and then, click on the **New Environment** button.


**2.** Enter a descriptive name for this environment, for example, *Azure Batch (east-us)*, and select **Azure Batch** as the target platform.

![](_images/azure_new_env_name.png) 


**3.** Add new credentials by selecting the **+** button. 

**4.** Choose a name, e.g. *tower credentials* and add the Access key and Secret key. 

*These are the keys we saved in the previous steps when creating the Azure resources.*

![](_images/azure_keys.png) 


!!! tip "Multiple credentials" 
    You can create multiple credentials in your Tower environment.

**5.** Select a **Region**, for example, *eastus (East US)*, and in the **Pipeline work directory** enter the Azure blob container we created in the previous section e.g: `az://towerrgstorage-container/work`.


![](_images/azure_blob_container_region.png) 

!!! warning 
    The blob container should be in the same **Region** as selected above.

**6.** Select the **Config mode** as **Batch Forge** and, optionally, add the default VM type depending on your quota limits. 

The default VM type is `Standard_D4_v3`.

![](_images/azure_tower_forge.png) 

**7.** Next, specify the maximum number of VMs you'd like to deploy in the `VMs count` field. 

**8.** Enable the **Autoscale** option, if you'd like to automatically scale up (`VMs count`) and down (`0` VMs) based on the number of tasks.

**9.** Enable the **Dispose resources** option if you'd like Tower to automatically delete the deployed **Pool** once the workflow is complete.

**Advanced options**

**10.** Optionally, specify the **Jobs cleanup policy** to delete the jobs once the workflow's execution is completed.

![](_images/azure_advanced_options.png) 


**11.** Optionally, specify the duration of the SAS token generated by Nextflow.


**12.** Finally, click on **Create** to finalize the compute environment setup. It will take approximately 20 seconds for all the resources to be created and then you will be ready to launch pipelines.

![](_images/azure_newly_created_env.png) 


Jump to the documentation section for [Launching Pipelines](../launch/launchpad.md).

## Launch


This section is for users with a pre-configured Azure environment. 

You will need an Azure Batch account, Azure Storage account already set up. 

To add a new compute environment in the Tower UI for existing Azure resources, follow these steps:

**1.** In a workspace choose **Compute environments** and then, click on the **New Environment** button.

**2.** Enter a descriptive name for this environment, for example, *Azure Batch (east-us)* and select **Azure Batch** as the target platform.

![](_images/azure_new_env_name.png) 


**3.** Add new credentials by selecting the **+** button. 

**4.** Choose a name, e.g. *tower credentials* and add the Access key and Secret key. 

*These are the keys we saved in the previous steps when creating the Azure resources.*

![](_images/azure_keys.png) 



!!! tip "Multiple credentials" 
    You can create multiple credentials in your Tower environment.



**5.** Select a **Region**, for example, *eastus (East US)*, and in the **Pipeline work directory** enter the Azure blob container we created in the previous section e.g: `az://towerrgstorage-container/work`.


![](_images/azure_blob_container_region.png) 

!!! warning 
    The blob container should be in the same **Region** as selected above.

**6.** Select the **Config mode** as **Manual**. 

**7.** Add the name of the Azure Batch pool, provided to you by your Azure administrator, in the **Compute Pool name** section.

![](_images/azure_tower_manual.png) 

**8.** You can specify certain environment variables on the Head job or the Compute job using the **Environment variables** option.

![](_images/env_vars.png)


**Advanced options**

**9.** Optionally, specify the **Jobs cleanup policy** to delete the jobs once the workflow's execution is completed.

![](_images/azure_advanced_options.png) 


**10.** Optionally, specify the duration of the SAS token generated by Nextflow.


**11.** Finally, click on **Create** to finalize the compute environment setup. 

It will take approximately 20 seconds for all the resources to be created and then you will be ready to launch pipelines.

![](_images/azure_newly_created_env.png) 


Jump to the documentation section for [Launching Pipelines](../launch/launchpad.md).
