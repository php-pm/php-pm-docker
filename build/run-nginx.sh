#!/bin/sh

trapIt () { "$@"& pid="$!"; trap "kill -INT $pid" INT TERM; while kill -0 $pid > /dev/null 2>&1; do wait $pid; ec="$?"; done; exit $ec;};

STATIC=/var/www/
[ ! -z "$PPM_STATIC" ] && STATIC="${STATIC}${PPM_STATIC}"

sed -i "s#STATIC_DIRECTORY#${STATIC}#g" /etc/nginx/sites-enabled/default

nginx

ARGS='--port=8080 --static-directory=""'
[ ! -z "$PPM_CONFIG" ] && ARGS="$ARGS -c $PPM_CONFIG"
[ ! -z "$PPM_DEBUG" ] && ARGS="$ARGS --debug=$PPM_DEBUG"
[ ! -z "$PPM_WORKER" ] && ARGS="$ARGS --worker=$PPM_WORKER"
[ ! -z "$PPM_APP_ENV" ] && ARGS="$ARGS --app-env=$PPM_APP_ENV"

trapIt /ppm/vendor/bin/ppm start --ansi $ARGS