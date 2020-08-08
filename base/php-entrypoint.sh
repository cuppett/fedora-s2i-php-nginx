#!/bin/sh
set -e

/usr/bin/php /usr/local/src/smarty/process_templates.php

exec "$@"