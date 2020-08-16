{* Smarty *}
worker_processes {$smarty.env.NGINX_WORKER_PROCESSES};
error_log /proc/self/fd/2 info;
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
        server_name  _;
        root  {$smarty.env.DOCUMENT_ROOT};
        index index.php index.html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

    }
}
