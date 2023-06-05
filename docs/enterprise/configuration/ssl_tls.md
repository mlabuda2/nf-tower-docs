---
layout: ../../layouts/HelpLayout.astro
title: "SSL/TLS configuration"
description: Configure Tower to use SSL/TLS certificates for HTTPS
date: "21 Apr 2023"
tags: [ssl, tls, https, configuration]
---

We recommend using public TLS certificates wherever possible. Private certificates are supported, but require additional configuration during Tower installation and Nextflow execution.

<!-- GW Note: Mar 22/23
Removed `export SSL_CERT_FILE=/TARGET_HOSTNAME.pem` from the Nextflow container configuration as I thought it
made sense to harmonize commands across the Tower & Nextflow containers (since they use the same underlying image).
-->

## Configure Nextflow Tower to trust your private certificate

If you secure related infrastructure (such as private git repositories) with certificates issued by a private Certificate Authority, these certificates must be loaded into the Tower Enterprise containers. You can achieve this in several ways.

??? example "Options"
    1. This guide assumes you are using the original containers supplied by Seqera.
    2. Replace `TARGET_HOSTNAME`, `TARGET_ALIAS`, and `PRIVATE_CERT.pem` with your unique values.
    3. Previous instructions advised using `openssl`. As of April 2023, the native `keytool` utility is preferred as it simplifies steps and better accommodates private CA certificates.
    === "Use Docker volume"

        1. Retrieve the private certificate on your Tower container host.
              ```
              keytool -printcert -rfc -sslserver TARGET_HOSTNAME:443  >  /PRIVATE_CERT.pem
              ```

        2. Modify the `backend` and `cron` container configuration blocks in _docker-compose.yml_.

            ```yaml
            CONTAINER_NAME:
              # -- Other keys here like `image` and `networks`--

              # Add a new mount for the downloaded certificate.
              volumes:
                - type: bind
                  source: /PRIVATE_CERT.pem
                  target: /etc/pki/ca-trust/source/anchors/PRIVATE_CERT.pem

              # Add a new keytool import line PRIOR to 'update-ca-trust' for the certificate.
              command: >
                sh -c "keytool -import -trustcacerts -storepass changeit -noprompt -alias TARGET_ALIAS -file /etc/pki/ca-trust/source/anchor/TARGET_HOSTNAME.pem &&
                      update-ca-trust &&
                      /wait-for-it.sh db:3306 -t 60 &&
                      /tower.sh"
            ```

    === "Use K8s ConfigMap"

        1. Retrieve the private certificate on a machine with CLI access to your Kubernetes cluster.

              ```bash
              keytool -printcert -rfc -sslserver TARGET_HOSTNAME:443 > /PRIVATE_CERT.pem
              ```

        2. Load the  certificate as a ConfigMap in the same namespace where your Tower instance will run.

              ```bash
              kubectl create configmap private-cert-pemstore --from-file=/PRIVATE_CERT.pem
              ```

        3. Modify both the `backend` and `cron` Deployment objects:

            1. Define a new volume based on the certificate ConfigMap.

                  ```yaml
                  spec:
                    template:
                      spec:
                        volumes:
                          - name: private-cert-pemstore
                            configMap:
                              name: private-cert-pemstore

                  ```

            2. Add a volumeMount entry into the container definition.

                  ```yaml
                  spec:
                    template:
                      spec:
                        containers:
                          - name: CONTAINER_NAME
                            volumeMounts:
                              - name: private-cert-pemstore
                                mountPath: /etc/pki/ca-trust/source/anchors/PRIVATE_CERT.pem
                                subPath: PRIVATE_CERT.pem
                  ```

            3. Modify the container start command to load the certificate prior to running Tower.

                  ```yaml
                  spec:
                    template:
                      spec:
                        containers:
                          - name: CONTAINER_NAME
                            command: ["/bin/sh"]
                            args:
                              - -c
                              - |
                                  keytool -import -trustcacerts -cacerts -storepass changeit -noprompt -alias TARGET_ALIAS -file /PRIVATE_CERT.pem;
                                  ./tower.sh
                  ```

    === "Download on Pod start"

        1. Modify both the `backend` and `cron` Deployment objects to retrieve and load the certificate prior to running Tower.

              ```yaml
              spec:
                template:
                  spec:
                    containers:
                      - name: CONTAINER_NAME
                        command: ["/bin/sh"]
                        args:
                          - -c
                          - |
                              keytool -printcert -rfc -sslserver TARGET_HOST:443  >  /PRIVATE_CERT.pem;
                              keytool -import -trustcacerts -cacerts -storepass changeit -noprompt -alias TARGET_ALIAS -file /PRIVATE_CERT.pem;
                              ./tower.sh
              ```


## Configure the Nextflow launcher image to trust your private certificate

If you secure infrastructure such as private git repositories or your Tower Enterprise instance with certificates issued by a private Certificate Authority, these certificates must also be loaded into the Nextflow launcher container.

??? example "Options"
    1. This guide assumes you are using the default `nf-launcher` image supplied by Seqera.
    2. Remember to replace `TARGET_HOSTNAME`, `TARGET_ALIAS`, and `PRIVATE_CERT.pem` with unique values.
    3. Previous instructions advised using `openssl`. As of April 2023, the native `keytool` utility is preferred as it simplifies steps and better accommodates private CA certificates.
    === "Import certificate via pre-run script"

        1. Add the following to your compute environment [pre-run script](https://help.tower.nf/launch/advanced/#workflow-entry-name):
          ```
          keytool -printcert -rfc -sslserver TARGET_HOSTNAME:443  >  /PRIVATE_CERT.pem
          keytool -import -trustcacerts -cacerts -storepass changeit -noprompt -alias TARGET_ALIAS -file /PRIVATE_CERT.pem

          cp /PRIVATE_CERT.pem /etc/pki/ca-trust/source/anchors/PRIVATE_CERT.pem
          update-ca-trust
          ```


## Configure Tower to present a SSL/TLS certificate

You can secure your Tower implementation with a TLS certificate in several ways.

??? example "Options"
    === "Load balancer (recommended)"

        Place a load balancer, configured to present a certificate and act as a TLS termination point, in front of the Tower application.

        This solution is likely already implemented for cloud-based Kubernetes implementations and can be easily implemented for Docker Compose-based stacks. See [this example](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-application-load-balancer.html).

    === "Reverse proxy container"

        This solution works well for Docker Compose-based stacks to avoid the additional cost and maintenance of a load balancer. See [this example](https://doc.traefik.io/traefik/v1.7/configuration/acme/).

    === "Modify `frontend` container"

        Due to complications that can be encountered during upgrades, this approach is not recommended.

        <details>
          <summary>Show me anyway</summary>

          This example assumes deployment on an Amazon Linux 2 AMI.

          1. Install nginx and other required packages:

              ```yml
              sudo amazon-linux-extras install nginx1.12
              sudo wget -r --no-parent -A 'epel-release-*.rpm' https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/
              sudo rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-*.rpm
              sudo yum-config-manager --enable epel*
              sudo yum repolist all
              sudo amazon-linux-extras install epel -y
              ```

          2. Generate a [private certificate and key](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs).

          3. Make a local copy of the `/etc/nginx/templates/tower.conf.template` file from the `frontend` container, or create a ConfigMap to store it, if you're using Kubernetes.

          4. Replace the `listen` directives in the `server` block with the following:

              ```conf
                  listen ${NGINX_LISTEN_PORT} ssl default_server;
                  listen [::]:${NGINX_LISTEN_PORT_SSL} ssl default_server;

                  ssl_certificate /etc/ssl/testcrt.crt;
                  ssl_certificate_key /etc/ssl/testkey.key;
              ```

          5. Modify the `frontend` container definition in your `docker-compose.yml` file, or similarly for a Kubernetes manifest:

              ```yml
              frontend:
              image: cr.seqera.io/frontend:${TAG}
              networks:
                  - frontend
              environment:
                NGINX_LISTEN_PORT: 8081
                NGINX_LISTEN_PORT_SSL: 8443
              ports:
                  - 8000:8081
                  - 443:8443
              volumes:
                  - $PWD/tower.conf.template:/etc/nginx/templates/tower.conf.template
                  - $PWD/cert/testcrt.crt:/etc/ssl/testcrt.crt
                  - $PWD/cert/testkey.key:/etc/ssl/testkey.key
              restart: always
              depends_on:
                  - backend
              ```
        </details>


## TLS version support

Tower Enterprise versions 22.3.2 and earlier rely on Java 11 (Amazon Corretto). You may encounter issues when integrating with third-party services that enforce `TLS v1.2` (e.g. Azure Active Directory OIDC).

`TLS v1.2` can be explicitly enabled by default using JDK environment variables:

```bash

_JAVA_OPTIONS="-Dmail.smtp.ssl.protocols=TLSv1.2

```

<!--- 13-4-2023: Keeping old intermediate CA solution for a lookback if needed.
```
javax.net.ssl.SSLHandshakeException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
at java.base/sun.security.ssl.Alert.createSSLException(Alert.java:131)
at java.base/sun.security.ssl.TransportContext.fatal(TransportContext.java:349)
at java.base/sun.security.ssl.TransportContext.fatal(TransportContext.java:292)
at java.base/sun.security.ssl.TransportContext.fatal(TransportContext.java:287)
at java.base/sun.security.ssl.CertificateMessage$T12CertificateConsumer.checkServerCerts(CertificateMessage.java:654)
        at java.base/sun.security.ssl.CertificateMessage$T12CertificateConsumer.onCertificate(CertificateMessage.java:473)
at java.base/sun.security.ssl.CertificateMessage$T12CertificateConsumer.consume(CertificateMessage.java:369)
at java.base/sun.security.ssl.SSLHandshake.consume(SSLHandshake.java:392)
```

#### SOLUTION 2: Adding intermediate certificates to your instance

To allow Java to automatically download missing intermediate certificates, activate the **enableAIAcaIssuers** system property via an environment variable:

```bash
export JAVA_OPTS="-Dcom.sun.security.enableAIAcaIssuers=true"
```
-->
