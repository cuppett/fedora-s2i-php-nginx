location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires {$smarty.env.NGINX_DEFAULT_EXPIRES};
}