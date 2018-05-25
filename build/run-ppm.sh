#!/bin/bash

trapIt () { "$@"& pid="$!"; trap "kill -INT $pid" INT TERM; while kill -0 $pid > /dev/null 2>&1; do wait $pid; ec="$?"; done; exit $ec;};

ARGS='--port 8080'
trapIt /ppm/vendor/bin/ppm start --ansi $@
