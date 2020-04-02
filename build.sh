#!/bin/bash

set -e
MY_PATH=`dirname $0`
APP_VERSION=$1
if [[ -z "${APP_VERSION}" ]]; then
	APP_VERSION="0.0.1"
fi
NODE_APP_NAME="skynode-${APP_VERSION}"
DATA_APP_NAME="skydata-${APP_VERSION}"
if [[ ! -f "${MY_PATH}/docker-compose.yml" ]]; then
    SECRET=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo ''`
    MYSQL_HOST=`cat "${MY_PATH}/docker-compose.yml.tmpl" | grep -m 1 -E 'MYSQL_HOST=' | sed -E 's/^\s+\-\s+MYSQL_HOST=//'`
    MYSQL_NAME=`cat "${MY_PATH}/docker-compose.yml.tmpl" | grep -m 1 -E 'MYSQL_NAME=' | sed -E 's/^\s+\-\s+MYSQL_NAME=//'`
    if [ -z "${MYSQL_HOST}" ] || [ -z "${MYSQL_NAME}" ]; then
        echo "Error parsing template file"
        exit 1
    fi
    cat "${MY_PATH}/docker-compose.yml.tmpl" | sed -e s/TERCES_POT/${SECRET}/ > "${MY_PATH}/docker-compose.yml"    
    cat "${MY_PATH}/config.php.tmpl" | sed -e "s/MYSQL_NAME/'${MYSQL_NAME}'/" \
        | sed -e "s/MYSQL_HOST/'${MYSQL_HOST}'/" | sed -e "s/MYSQL_PASS/'${SECRET}'/" > "${MY_PATH}/config.php"
fi

docker build -t "aquila:${DATA_APP_NAME}" -f "${MY_PATH}/Dockerfile.data" "${MY_PATH}"
docker build -t "aquila:${NODE_APP_NAME}" -f "${MY_PATH}/Dockerfile.node" "${MY_PATH}"
echo "Job is completed!"
echo "Run docker-compose up -d to start application"
