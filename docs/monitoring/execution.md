---
title: Execution details & logs
headline: 'Monitoring & Logs'
description: 'Monitoring a Nextflow pipeline executed through Tower.'
---

Selecting a pipeline on the navigation bar will display the workflow details in the main monitoring panel. The main window contains:

* [Execution section](#run-information) with command-line, parameters, configuration, and execution logs in real-time.
* [Summary](./summary.md) and [status section](./summary.md).
* List of pipeline [processes](./processes.md).
* Aggregated [stats](./aggregate_stats.md) and [load](./aggregate_stats.md#load-and-utilization).
* Detailed list of [individual tasks](./tasks.md#task-table) and [metrics](./tasks.md#resource-metrics).

## Run information

This top section is composed of 4 tabs containing details about the Nextflow execution:

**1.** The Nextflow **Command line** to execute the job.

**2.** **Parameters** including all parameters given in the arguments and arguments taken from the configuration `profiles` in the `params` scope.

**3.** **Configuration** contains all the information included in the configuration file including parameters.

**4.** The **Execution log** tab is updated in real time with the logs from the main Nextflow process.

![](_images/monitoring_exec_log.png)

