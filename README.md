# Docker Compose for TheHive and Cortex

> **IMPORTANT** all files in the `testing` folder are meant for prototyping, they **MUST NOT** be used in production

This repository contains a Docker Compose file used to setup TheHive and Cortex on a server for testing purpose.
Later versions will include production-ready Docker Compose files to deploy these containers on separate instances.


## Disclaimer

This repository is designed to be a template and will require adjustments to suit your specific environment.
In particular, you should review (and modify if needed):
- Environment variables
- Network configurations (to avoid conflicts with existing services)
- Docker bind mounts (e.g. tweak location, add backups...)
- Containers resources limits (to make containers fit inside your machine)
- Service dependencies (make sure all services are properly configured and reachable)

Failure to customize these files may lead to errors and crash in services or conflicts within your environment.
Please consult the documentation and seek assistance if needed to make the necessary adjustments.

By using this repository, you acknowledge that it is your responsibility to tailor configurations to your environment.
Maintainers of this repository are not liable for any issue related to improper configurations.


## Requirements

Hardware requirements:
- At least 2 vCPUs dedicated to containers
- At least 2GB of RAM per container (8GB total)

Software requirements:
- Docker engine `v23.0.15` and later ([install instructions](https://docs.docker.com/engine/install/))
- Docker Compose plugin `v2.20.2` and later ([install instructions](https://docs.docker.com/compose/install/))

To verify that everything is properly installed, you can do the following commands:
```bash
# Check Docker engine version
docker version

# Check that the current user can run Docker commands
# Else (for Linux) check out https://docs.docker.com/engine/install/linux-postinstall/
docker run hello-world

# Check Docker Compose plugin version
docker compose version
```


## Configuration
### Structure

The testing Docker Compose file is based on the following structure:
```
├── cassandra
│   ├── data
│   └── logs
├── cortex
│   ├── config
│   ├── logs
│   └── neurons
├── docker-compose.yml
├── dot.env.template
├── elasticsearch
│   ├── data
│   └── logs
└── thehive
    ├── config
    ├── data
    └── logs
```

Here are the main takeaways:
- The `dot.env.template` defines important variables for the Docker Compose (see [Usage](./README.md#usage))
- Every `config`, `data` and `logs` folder are synchronised with their associated container using [Docker bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
    * Permission management of these folders is paramount to prevent errors (see [Permissions](./README.md#permissions))
- Cortex is an exception with additional mountpoints:
    * `/var/run/docker.sock` to allow Cortex access to the host's Docker daemon and launch containers
    * `/tmp/cortex-jobs` (also in the command flags) for Cortex to store jobs


### Permissions

To simplify operations, we recommend to use the host's user in the containers (see [Usage](./README.md#usage)):
- You should make sure that all `config`, `data` and `logs` folders are owned and writable by the host's user
- In case of misconfiguration, end users may need to be sudoers to access / modify / remove data written by containers


## Usage
### Quick start

> **NOTE** launched containers will listen on localhost by default, see [Exposing containers](./README.md#exposing-containers) for details

1. Copy the content of the folder `testing` on your server
2. Run `bash ./scripts/init.sh` to generate .env file and prepare the environment
3. Launch all containers using
```bash
docker compose up -d
```

After a short while, containers should be running and healthy. Try the following links:
- TheHive at `http://127.0.0.1:9000`
- Cortex at `http://127.0.0.1:9001`

You can check the status of running containers with:
```bash
docker ps
```

To manage running containers, go in the folder with the `docker-compose.yml` and run:
```bash
# Start / stop containers
docker compose start
docker compose stop

# Stop and remove containers and network
docker compose down
```


### Advanced configuration
#### TheHive and Cortex

> **WARNING** changing the provided config can have unintended side-effects

TheHive and Cortex can be customized by:
- Modifying config files under `thehive/config` and `cortex/config` folders
- Changing containers command at startup (e.g. [adding parameters](https://docs.strangebee.com/cortex/installation-and-configuration/run-cortex-with-docker/))


#### Exposing containers

The setup to expose containers on a network can vary wildly depending on the context.
It is recommended to use a [reverse proxy](https://docs.strangebee.com/thehive/configuration/ssl/) to forward requests from outside to containers in a secure way.
While [exposing containers directly on the host's IP](https://docs.docker.com/engine/network/drivers/host/) is possible, it is not recommended for security reasons.


#### Technical choices

The Docker Compose file defines healthchecks for all containers. It is used to:
- Make sure applications within containers are running properly
- Create hard dependencies between services (e.g. TheHive needs Cassandra and ElasticSearch healthy to run properly)

Containers resources are defined as follow:
- Each container has access to 2GB of memory at most
- Java environment variables are defined to fit within this amount of memory
- Swap is disabled to prevent performance gaps

Changing these values can improve the responsiveness of the services, but you should make sure that all connected variables are updated to reflect the change.

Finally, we use [variable interpolation](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/) so that the Docker Compose file takes its variables from the `.env` file.
