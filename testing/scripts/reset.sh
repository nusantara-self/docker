#! /usr/bin/env bash

read -p "This program will completely reset the application stack. All data will be lost. Continue ? (y/n): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]
then
  ## Stop services
  docker compose down



  ## Restore permissions
  CURRENT_USER_ID=$(id -u)
  CURRENT_GROUP_ID=$(id -g)
  UNEXPECTED_OWNERSHIP=$(find . ! -user ${CURRENT_USER_ID} -o ! -group ${CURRENT_GROUP_ID})

  if [ -n "${UNEXPECTED_OWNERSHIP}" ];
  then
    echo "${UNEXPECTED_OWNERSHIP}" | while IFS= read -r line; do
      sudo chown ${CURRENT_USER_ID}:${CURRENT_GROUP_ID} "${line}"
      echo "* Ownership updated for ${line}"
      done
    
    [[ $? -ne 0 ]] && echo -n "
!!! Run this command with root privileges to complete the reset process: 
# find . ! -user ${CURRENT_USER_ID} -o ! -group ${CURRENT_GROUP_ID} -exec chown ${CURRENT_USER_ID}:${CURRENT_GROUP_ID} {} \; "
  fi

  ## Delete folder contents
  DIRECTORIES="./cassandra/data ./cassandra/logs  elasticsearch/data elasticsearch/logs  ./thehive/data/files ./thehive/logs ./cortex/logs"

  for D in ${DIRECTORIES}
  do
    rm -rf ./${D}/*
  done

  ## DELETE secret.conf FILES
  rm ./thehive/config/secret.conf
  rm ./cortex/config/secret.conf
  rm -rf ./cortex/config/application.conf.d

  ## DELETE .env FILE
  rm .env
else
  exit 0
fi