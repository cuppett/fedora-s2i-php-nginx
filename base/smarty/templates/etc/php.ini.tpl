{* Smarty *}
[PHP]

short_open_tag = Off
max_execution_time = 30
max_input_time = 60
{* This next variable required in the base php.ini before we run anything else *}
variables_order = "GPCSE"
memory_limit = {if isset($smarty.env.PHP_MEMORY_LIMIT) }{$smarty.env.PHP_MEMORY_LIMIT}{else}128M{/if}

error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
display_startup_errors = Off
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = On
ignore_repeated_source = Off
track_errors = Off
allow_url_fopen = On
allow_url_include = Off
