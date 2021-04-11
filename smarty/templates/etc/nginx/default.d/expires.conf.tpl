{* Smarty *}
{if isset($smarty.env.NGINX_DEFAULT_EXPIRES) }
location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires {$smarty.env.NGINX_DEFAULT_EXPIRES};
    log_not_found off;
}
{/if}
