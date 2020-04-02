#!/bin/sh

set -e
MY_PATH=`dirname $0`
MSG_NAVAR="Environment variable not defined:"
if [ -z "${APP_HOME}" ]; then
    echo "${MSG_NAVAR} APP_HOME"
    exit 1
else
    echo "  APP_HOME: ${APP_HOME}"
fi
if [ -z "${MYSQL_HOST}" ]; then
    echo "${MSG_NAVAR} MYSQL_HOST"
    exit 1
else
    echo "MYSQL_HOST: ${MYSQL_HOST}"
fi

docker-php-entrypoint "$@"
