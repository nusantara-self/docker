#!/bin/bash

## This scripts should be run from the directory containing the file `docker-compose.yml` with the following command: 
##  bash ./scipts/init.sh

STATUS=0

init() {
    ## INIT THEHIVE CONFIGURATION
    THEHIVESECRETFILE="./thehive/config/secret.conf"
    if [ ! -f ${THEHIVESECRETFILE} ] 
    then
        cat > ${THEHIVESECRETFILE} << _EOF_
play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
_EOF_
    else
        STATUS=1
        echo "${THEHIVESECRETFILE} file already exists and has not been modified."
    fi

    ## INIT CORTEX CONFIGURATION
    CORTEXSECRETFILE="./cortex/config/secret.conf"
    if [ ! -f ${CORTEXSECRETFILE} ] 
    then
        cat > ${CORTEXSECRETFILE} << _EOF_
play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)" 
_EOF_
    else
        STATUS=1
        echo "${CORTEXSECRETFILE} file already exists and has not been modified."
    fi

    ## CREATE .env FILE
    ENVFILE="./.env"
    if [ ! -f ${ENVFILE} ] 
    then
        CURRENT_USER_ID=$(id -u)
        CURRENT_GROUP_ID=$(id -g)

        cp dot.env.template .env
        cat >> ${ENVFILE} << _EOF_
## CONFIGURATION AUTOMATICALLY ADDED BY .scripts/init.sh PROGRAM.
# System variables
UID=${CURRENT_USER_ID}
GID=${CURRENT_GROUP_ID}
_EOF_
    else
        STATUS=1
        echo "${ENVFILE} file already exists and has not been modified."
        exit 0
    fi

    if [ ${STATUS} == 0 ]
    then
        echo -n "Initialisation completed. run the following command to start applications:
        $ docker compose up
        "
        exit 0
    fi
}


## ENSURE PERMISSIONS ARE WELL SET BEFORE INITIALISING
bash $(dirname $0)/check_permissions.sh

if [ $? -eq 0 ]
then
    init
else
    echo "Initialisation did not complete due to permissions issue. Please run ./scripts/check_permissions.sh to check" 
fi

