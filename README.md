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
  

## Build your own docker image for the documentation

### Generate a token on git.seqera.io

In order to build the docker container to serve the mkdocs site is necessary to generate a token on gitea.
- Go to [git.seqera.io](https://git.seqera.io) and use your credentials to access
- In the top right menu click on your avatar and click on `Settings` from the dropdown menu
- On the top part of the page select `Applications`
- Generate a new token and copy the value after form submission
- Put the token into a env variable GITEA_TOKEN and/or store it in .bashrc/.zshrc. Run `source .bashrc` or `source .zshrc` once saved.

### Build docs image

Build the `seqera-docs` image:

`docker build --build-arg GITEA_TOKEN=${GITEA_TOKEN} -t seqera-docs .`

The above command can be replaced with `make build-docker`.

### How to run documentation locally

Once command above has been run successfully use the command below to serve the documentation locally
`docker run --rm -p 8000:8000 -v ${PWD}:/docs seqera-docs:latest serve --dev-addr=0.0.0.0:8000`

Visit 0.0.0.0:8000 from your favorite browser.
