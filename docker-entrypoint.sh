#!/bin/bash
set -e

# start cron daemon
/usr/sbin/cron

# start php-fpm
exec "$@"
