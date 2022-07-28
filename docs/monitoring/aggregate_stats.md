---
title: Aggregate stats & load
headline: 'Aggregate stats and resources'
description: 'Statistics and resources usage of Nextflow pipelines executed through Tower.'
---

## Aggregate Stats

The **Aggregate stats** panel displays a real-time summary of the resources used by the workflow. These include total running time ('wall time'), aggregated CPU time (CPU hours), memory usage (GB hours), data i/o and cost.

![](_images/monitoring_aggregate_stats.png)

The cost is only based on estimated computation usage and does not currently take into account storage or associated network costs. Tower has a database of costs for all cloud instances of AWS and Google Cloud in all regions and zones.

**Estimation details**

The cost of each task is calculated using `(instance cost/h) * (fraction of the instance used by the task) * (time)`.

The fraction of an instance is calculated using the concepts of CPU and memory slots. The fraction of the instance used by the task is the maximum ratio between the requested CPUs over available CPUs, and the ratio between the requested memory over the available memory.

For example: a task requests 1 CPU and 1 GB of memory and it runs on a 4 CPUs 8GB RAM instance.  
In this case, the fraction of the insteance used by the task will be 0.25 (1 CPU/4 CPUs).


!!! warning 
    The total workwlow cost estimation is the sum of the individual task estimations. This will underestimate the costs when an instance is being used at 100% of its CPU or memory capacity.
    
!!! warning
    The total workflow cost estimation does not include the cost incurred by the head job. 

## Load and Utilization

As processes are being submitted to the compute environment, the **Load** monitors how many cores and tasks are currently being used. 

**Utilization** is calculated for memory and CPUs. This is the average value across all tasks and is calculated by dividing the memory (or CPUs) usage by the memory (or CPUs) requested.

![](_images/monitoring_load.png)

