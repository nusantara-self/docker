#! /usr/bin/env bash

## This program initialisa and configure Cortex and TheHive, with sample data. This allows to check everything works fine. 
## Reset the application stack by running the command: bash ./scripts/reset.sh

## Initialize Cortex
echo "--- Initializing Cortex"
bash $(dirname $0)/test_init_cortex.sh

## initialize TheHive
echo "--- Initializing TheHive" 
bash $(dirname $0)/test_init_thehive.sh


REPORT="
Cortex has been initialized with following accounts: 

* Cortex URL: http://localhost:9001
* Administrator:
  Login: admin
  Password: thehive1234

* An Organisation is also created with an orgadmin account:
  Login: thehive
  Password: thehive1234


TheHive has been initialized with following accounts: 

* TheHive URL: http://localhost:9000
* Administrator:
  Login: admin@thehive.local
  Password: secret

* A user named thehive has been created and is org-admin of the organisation named demo:
  Login: thehive@thehive.local
  Password: thehive1234


TheHive is already integrated with Cortex, and few analyzers are enabled by default.
"


echo -e "${REPORT}"
