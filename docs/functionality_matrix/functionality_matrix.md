---
title: Tower / Nextflow compatibility matrix
headline: 'Tower / Nextflow compatibility matrix'
description: 'Tower / nf-launcher / Nextflow version compatibility matrix'
---

### Tower / Nextflow version compatibility

Each Tower version makes use of `nf-launcher` to determine the Nextflow version used as its baseline. This Nextflow version can be overridden with the `NXF_VER` environment variable in your `nextflow.conf` file, but note that Tower may not work reliably with Nextflow versions other than the baseline version.

We officially support the two latest major releases (22.3.x, 22.4.x, etc) of Tower at any given time. 

nf-launcher versions prefixed with j17 refer to Java version 17; j11 refers to Java 11. As of Tower 22.4, Java 17 is recommended.  

| Tower version | nf-launcher version | Nextflow version |
|-----|-----|-----|
| 22.3.1 | j17-22.10.4 | 22.10.4 |
| 22.3 | j17-22.10.1 | 22.10.1 |
| 22.2.4 | j17-22.06.1-edge | 22.06.1-edge |
| 22.2.3 | j11-22.06.1-edge | 22.06.1-edge |
| 22.2.2 | j17-22.08.0-edge | 22.08.0-edge |
| 22.2.1 | j17-22.06.1-edge | 22.06.1-edge | 
| 22.2.0 | j17-22.06.1-edge | 22.06.1-edge | 
-----

If no Nextflow version is specified in your configuration, Tower defaults to the baseline version outlined above. 

### Tower / Tower CLI version compatibility

Each version of Tower is compatible with the latest version of Tower CLI at the time of release. 