#! /usr/bin/env bash

## Stop services
docker compose down



# Restore permissions
CURRENT_USER_ID=$(id -u)
CURRENT_GROUP_ID=$(id -g)


# Temporary: change permissions on Cortex folder
sudo chown -R ${CURRENT_USER_ID}:${CURRENT_GROUP_ID}  ./cortex

## delete folder contents
DIRECTORIES="./cassandra/data ./cassandra/logs  elasticsearch/data elasticsearch/logs  ./thehive/data/files ./thehive/logs ./cortex/logs"

for D in ${DIRECTORIES}
do
  rm -rf ./${D}/*
done

## DELETE secret.conf FILES
rm ./thehive/config/secret.conf
rm ./cortex/config/secret.conf

## DELETE .env FILE
rm .env
