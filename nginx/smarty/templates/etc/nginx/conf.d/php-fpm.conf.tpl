upstream php-fpm {
        server {if isset($smarty.env.FCGI_HOST) }{$smarty.env.FCGI_HOST}{else}127.0.0.1:9000{/if};
}
