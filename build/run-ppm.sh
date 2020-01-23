#!/bin/bash

trapIt () { "$@"& pid="$!"; for SGNL in INT TERM CHLD USR1; do trap "kill -$SGNL $pid" "$SGNL"; done; while kill -0 $pid > /dev/null 2>&1; do wait $pid; ec="$?"; done; exit $ec; };

trapIt /ppm/vendor/bin/ppm --ansi "$@"
