#!/bin/bash
set -e

# exec rc.local
echo "Execute /etc/rc.local"
/etc/rc.local 2>&1

# start cron daemon
echo "Start cron daemon"
/usr/sbin/cron

# start php-fpm
echo "Start php-fpm"
exec "$@"
