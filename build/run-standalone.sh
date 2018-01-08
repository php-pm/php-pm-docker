trapIt () { "$@"& pid="$!"; trap "kill -INT $pid" INT TERM; while kill -0 $pid > /dev/null 2>&1; do wait $pid; ec="$?"; done; exit $ec;};

ARGS='--port 80'
[ ! -z "$PPM_CONFIG" ] && ARGS="-c $PPM_CONFIG"
[ ! -z "$PPM_DEBUG" ] && ARGS="$ARGS --debug $PPM_DEBUG"
[ ! -z "$PPM_STATIC" ] && ARGS="$ARGS --static-directory $PPM_STATIC"
[ ! -z "$PPM_WORKER" ] && ARGS="$ARGS --worker=$PPM_WORKER"
[ ! -z "$PPM_APP_ENV" ] && ARGS="$ARGS --app-env=$PPM_APP_ENV"

trapIt /ppm/vendor/bin/ppm start $ARGS