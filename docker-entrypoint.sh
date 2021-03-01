#!/bin/bash
set -e

if [ "$1" = 'pwrstat-exporter' ]; then
  pwrstatd &
  sleep 5 # wait for the daemon to be up
  pwrstat -pwrfail -shutdown off
  pwrstat -pwrfail -active off
  pwrstat -lowbatt -shutdown off
  pwrstat -lowbatt -active off
fi

exec "$@"
