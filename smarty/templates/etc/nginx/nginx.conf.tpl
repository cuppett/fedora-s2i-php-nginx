{* Smarty *}
worker_processes {$smarty.env.NGINX_WORKER_PROCESSES};
error_log /proc/self/fd/2 error;
pid /run/nginx/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections {$smarty.env.NGINX_WORKER_CONNECTIONS};
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log   /proc/self/fd/1 main;

    sendfile             on;
    tcp_nopush           on;
    tcp_nodelay          on;
    keepalive_timeout    65;
    proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
    fastcgi_read_timeout {$smarty.env.NGINX_FASTCGI_READ_TIMEOUT};
    proxy_read_timeout   {$smarty.env.NGINX_FASTCGI_READ_TIMEOUT};
    types_hash_max_size  4096;
    client_max_body_size {$smarty.env.NGINX_CLIENT_MAX_BODY_SIZE};

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {

        listen       {$smarty.env.NGINX_LISTEN_PORT};
        listen       [::]:{$smarty.env.NGINX_LISTEN_PORT};
        server_name  {if isset($smarty.env.SERVER_NAME) }{$smarty.env.SERVER_NAME}{else}_{/if};
        root  /var/www/html{$smarty.env.DOCUMENTROOT};
        index index.php index.html /index.php$request_uri;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location = /stub_status {
            stub_status;
            allow          127.0.0.1;
            allow          10.0.0.0/8;
            allow          172.16.0.0/12;
            allow          192.168.0.0/16;
            deny           all;
            access_log off;
        }
    }

    {if file_exists('/etc/nginx/certs/tls.crt') && file_exists('/etc/nginx/certs/tls.key')}
    server {
        listen              {$smarty.env.NGINX_LISTEN_SSL_PORT} ssl;
        listen              [::]:{$smarty.env.NGINX_LISTEN_SSL_PORT} ssl;
        server_name         {if isset($smarty.env.SERVER_NAME) }{$smarty.env.SERVER_NAME}{else}_{/if};
        ssl_certificate     /etc/nginx/certs/tls.crt;
        ssl_certificate_key /etc/nginx/certs/tls.key;
        ssl_protocols       TLSv1.2 TLSv1.3;
        ssl_ciphers         'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
        ssl_ecdh_curve      secp384r1;
        ssl_buffer_size     8k;
        ssl_prefer_server_ciphers   on;
        ssl_dhparam /etc/nginx/dhparam.pem;

        root  /var/www/html{$smarty.env.DOCUMENTROOT};
        index index.php index.html /index.php$request_uri;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;
    }
    {/if}
}
