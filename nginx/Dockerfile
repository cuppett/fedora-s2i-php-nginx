FROM quay.io/cuppett/fedora-php-s2i-base:32

ENV SUMMARY="NGINX image which allows using of source-to-image, PHP commands and Smarty templates."	\
    DESCRIPTION="The nginx image provides any images layered on top of it \
with all the tools needed to use NGINX and/or source-to-image functionality while keeping \
the image size as small as possible." \
    NAME=fedora-nginx \
    VERSION=32

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$NAME" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      usage="This image is supposed to be used as a base image for other images that support PHP or source-to-image" \
      maintainer="Stephen Cuppett <steve@cuppett.com>"

USER 0

# install the basic nginx environment
RUN set -ex; \
    \
    dnf -y install \
        nginx \
        httpd-filesystem \
    ; \
    \
# reset dnf cache
    dnf -y clean all; \
    rm -rf /var/cache/dnf

COPY smarty /usr/local/src/smarty

ENV FCGI_HOST="127.0.0.1:9000"
ENV NGINX_WORKER_PROCESSES="auto"
ENV NGINX_WORKER_CONNECTIONS="1024"
ENV NGINX_LISTEN_PORT="8080"
ENV NGINX_DEFAULT_EXPIRES="modified +24h"

# set permissions up on the runtime locations
RUN set -ex; \
    mkdir /run/nginx ; \
    mkdir -p /etc/nginx/{conf.d,default.d}; \
    fix-permissions /etc/nginx; \
    fix-permissions /run/nginx; \
    fix-permissions /var/www; \
    /usr/bin/php /usr/local/src/smarty/compile_templates.php

EXPOSE 8080

VOLUME /var/www/html

USER 1001

CMD ["nginx"]
