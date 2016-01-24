#!/bin/bash
set -e

if [ "$1" = 'start_all' ]; then
	gosu redis-server /etc/redi/redis.conf
fi

exec "$@"
