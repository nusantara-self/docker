#!/bin/bash

## ============================================================
## BACKUP SCRIPT FOR THEHIVE APPLICATION STACK
## ============================================================
## PURPOSE:
## This script creates a backup of TheHive application stack, 
## including its configuration, data, and logs. It is designed 
## to ensure data is preserved for restoration purposes.
##
## IMPORTANT:
## - This script must be run with appropriate permissions to read all data 
##   and write to the backup folders.
## - Ensure sufficient storage is available in the backup location to avoid 
##   partial or failed backups.
## - Services (Elasticsearch, Cassandra, and TheHive) will be stopped during 
##   the backup process to ensure data integrity.
##
## DISCLAIMER:
## - Users are strongly advised to test this script in a non-production 
##   environment to ensure it works as expected with their specific 
##   infrastructure and application stack before using it in production.
## - The maintainers of this script are not responsible for any data loss, 
##   corruption, or issues arising from the use of this script during your 
##   backup or restore processes. Proceed at your own risk.
##
## USAGE:
## 1. Update the variables at the start of the script to reflect your setup:
##    - BACKUP_ROOT_FOLDER: Root folder where backups will be stored.
##    - BACKUP_TO_RESTORE: Name of the backup folder to restore.
## 2. Run the script using the following command:
##    `bash ./scripts/backup.sh`
##
## ADDITIONAL RESOURCES:
## Refer to the official documentation for detailed instructions and 
## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/
##
## WARNING:
## - This script stops Nginx, Elasticsearch and Cortex services, 
##   performs the backup, and then restarts the services.
## - Do not modify the rest of the script unless necessary.
##
## ============================================================


## ============================================================
## USER-CONFIGURABLE VARIABLES
## ============================================================
##
## Update the following variables to match your environment
## Path to the docker-compose.yml file
DOCKER_COMPOSE_PATH="./"
## Root folder for storing backups
BACKUP_ROOT_FOLDER="./backup"
## ============================================================
## DO NOT MODIFY ANYTHING BELOW THIS LINE
## ============================================================

DATE="$(date +"%Y%m%d-%H%M%z" | sed 's/+/-/')"
BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/${DATE}"


## Stop services
docker compose stop

## Create the backup directory
mkdir -p "${BACKUP_FOLDER}"  || { echo "Creating backup folder failed"; exit 1; }
echo "Created backup folder: ${BACKUP_FOLDER}"

## Define the log file and start logging
LOG_FILE="${BACKUP_ROOT_FOLDER}/backup_log_${DATE}.log"
exec &> >(tee -a "$LOG_FILE")



## Prepare folders tree
mkdir -p ${BACKUP_FOLDER}/{thehive,cassandra,elasticsearch,nginx,certificates}
echo "Created folder structure under ${BACKUP_FOLDER}"

## Copy Cortex data
echo "Starting Cortex backup..."
rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/cortex/ ${BACKUP_FOLDER}/cortex || { echo "Cortex backup failed"; exit 1; }
echo "Cortex backup completed."

## Copy Elasticsearch data
echo "Starting Elasticsearch backup..."
rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch || { echo "Elasticsearch config backup failed"; exit 1; }
echo "Elasticsearch backup completed."

## Copy Nginx certificates
echo "Starting backup of Nginx and certificates..."
rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/nginx/ ${BACKUP_FOLDER}/nginx || { echo " Backup of Nginx failed"; exit 1; }
rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/certificates/ ${BACKUP_FOLDER}/certificates || { echo " Backup of Nginx and certificates failed"; exit 1; }
echo "Backup of certificates completed."

## Restart services
echo "Restarting services..."
docker compose up -d 



echo "Backup process completed at: $(date)"
