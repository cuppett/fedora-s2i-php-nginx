FROM quay.io/cuppett/fedora-s2i-php:34-base

ENV SUMMARY="NGINX image which allows using of source-to-image, PHP commands and Smarty templates."	\
    DESCRIPTION="The nginx image provides any images layered on top of it \
with all the tools needed to use NGINX and/or source-to-image functionality while keeping \
the image size as small as possible." \
    NAME=fedora-nginx \
    DOCUMENTROOT="" \
    FCGI_HOST="127.0.0.1:9000" \
    NGINX_FASTCGI_READ_TIMEOUT="60" \
    NGINX_WORKER_PROCESSES="auto" \
    NGINX_WORKER_CONNECTIONS="1024" \
    NGINX_LISTEN_PORT="8080" \
    NGINX_LISTEN_SSL_PORT="8443" \
    NGINX_CLIENT_MAX_BODY_SIZE="32m"

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
        openssl \
        httpd-filesystem \
    ; \
    \
# reset dnf cache
    dnf -y clean all

COPY smarty /usr/local/src/smarty
# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY s2i/bin/ $STI_SCRIPTS_PATH

# set permissions up on the runtime locations
RUN set -ex; \
    mkdir /run/nginx ; \
    fix-permissions /run/nginx; \
    fix-permissions /var/www; \
    mkdir -p /etc/nginx/{conf.d,default.d,certs}; \
    chgrp -R 0 /etc/nginx/* ; \
    chmod g+w -R /etc/nginx/* ; \
    chgrp -R 0 /usr/local/src/* ; \
    chmod g+w -R /usr/local/src/* ; \
    /usr/bin/php /usr/local/src/smarty/compile_templates.php ; \
    openssl dhparam -out /etc/nginx/dhparam.pem 2048

EXPOSE 8080
EXPOSE 8443

VOLUME /var/www/html

USER 1001

CMD ["nginx", "-g", "daemon off;"]
