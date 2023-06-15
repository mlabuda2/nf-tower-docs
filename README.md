# Nextflow Tower documentation 

This repository contains the publishing project for https://help.tower.nf. Create an issue to request documentation fixes and improvements. 

Do not edit the markdown files in this repo, they are ported from [nf-tower-cloud](https://github.com/seqeralabs/nf-tower-cloud/tree/master/docs). Content additions and edits must be performed in the nf-tower-cloud repo.

Building the docs depends on [`mkdocs`](https://www.mkdocs.org/), [`mkdocs-material`](https://squidfunk.github.io/mkdocs-material/getting-started/), and [`mike`](https://github.com/jimporter/mike). 

## Build a Docker image for the documentation

### Generate a token on git.seqera.io

To build the Docker container to serve the mkdocs site, you must generate a token on Gitea.
- Log in to [git.seqera.io](https://git.seqera.io) using your Seqera credentials
- In the top right menu, click on your avatar and select `Settings` from the drop-down menu
- Select `Applications` near the top of the page
- Generate a new token and copy the value after form submission
- Store the token value as a `GITEA_TOKEN` environment variable, optionally added to .bashrc/.zshrc. Run `source .bashrc` or `source .zshrc` once saved.

### Build docs image

Build the `seqera-docs` image:

`docker build --build-arg GITEA_TOKEN=${GITEA_TOKEN} -t seqera-docs .`

This command can be replaced with `make build-docker`.

### Run documentation locally

Once the Docker command above has been run successfully, use this command to serve the documentation locally:
`docker run --rm -p 8000:8000 -v ${PWD}:/docs seqera-docs:latest serve --dev-addr=0.0.0.0:8000`

Visit 0.0.0.0:8000 from your favorite browser.
