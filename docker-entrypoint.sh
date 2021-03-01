#!/bin/bash
set -e

if [ "$1" = 'pwrstat-exporter' ]; then
  pwrstatd &
  pwrstat -pwrfail -shutdown off
  pwrstat -pwrfail -active off
  pwrstat -lowbatt -shutdown off
  pwrstat -lowbatt -active off
  pwrstat -config
fi

exec "$@"