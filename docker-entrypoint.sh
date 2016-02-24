#!/bin/bash
set -e

# exec rc.local
/etc/rc.local

# start cron daemon
/usr/sbin/cron

# start php-fpm
exec "$@"
