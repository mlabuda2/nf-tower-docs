# Nextflow Tower documentation 

## Get started

Clone the repository.
```
git clone https://github.com/seqeralabs/nf-tower-docs.git
```

Building the docs depends on [`mkdocs`](https://www.mkdocs.org/), [`mkdocs-material`](https://squidfunk.github.io/mkdocs-material/getting-started/) as well as [`mike`](https://github.com/jimporter/mike).


Move to the working directory, e.g: `cd nf-tower-docs`.

Build and run the mkdocs server:
```
make serve
```

This launches a site that runs locally at http://localhost:8000.

**NOTE**: There is a `Makefile` in the repository to simplify the deployment.

## Build and publishing 

The docs build automatically when pushing a change. 

Changes on the `master` branch are automatically published to the S3 bucket `help.tower.nf` 
and accessible at http://help.tower.nf
  
