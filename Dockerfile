FROM python:3.9
ARG GITEA_TOKEN

COPY requirements.txt .
RUN pip install -r requirements.txt \
      && pip install "git+https://${GITEA_TOKEN}@git.seqera.io/seqeralabs/mkdocs-material-insiders@7.3.3-insiders-3.1.3"

WORKDIR /docs
ENTRYPOINT ["mkdocs"]
