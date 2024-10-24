# Docker compose for TheHive and Cortex

> **IMPORTANT** all files in the `testing` folder are meant for prototyping, they **MUST NOT** be used in production

This repository contains a docker compose file used to setup TheHive and Cortex on a server for testing purpose.
Later versions will include production-ready compose files to deploy these containers on separate instances.


## Requirements

Hardware requirements:
- At least 2 vCPUs dedicated to containers
- At least 2GB of RAM per container (8GB total)

Software requirements:
- Docker engine `v23.0.15` and later ([install instructions](https://docs.docker.com/engine/install/))
- Docker compose plugin `v2.20.2` and later ([install instructions](https://docs.docker.com/compose/install/))

To verify that everything is properly installed, you can do the following commands:
```bash
# Check docker engine version
docker version

# Check that the current user can run docker commands
# Else (for Linux) check out https://docs.docker.com/engine/install/linux-postinstall/
docker run hello-world

# Check docker compose plugin version
docker compose version
```


## Configuration

Each Compose file runs Elasticsearch, Cassandra and TheHive.

* *Elasticsearch* database and logs are stored in Docker volumes
* *Cassandra* database and logs are stored in Docker volumes
* *TheHive* configuration, attachments and logs files are stored in `./thehive` folder.


## Usage

For testing purpose:

1. Copy the content of the folder `testing` on your server,
2. Update the `docker-compose.yml` to suit your requirements,
3. Update `./thehive/config/secret.conf` with a secret key
4. Run:

    ```bash
    docker compose up
    ```

First start will create volumes for:

* Elasticsearch database
* Elasticsearch logs
* Cassandra database
* Cassandra logs

TheHive attachments files are stored in `./thehive/data/files/` and logs are stored in `./thehive/log/`.


## Disclaimer

**Important Notice**
These compose files are designed to be templates and may require adjustments to suit your specific environment. The configuration and Docker Compose files provided in this repository are tailored to a general setup and should be modified to match your unique requirements and infrastructure.

**Key Points to Consider**
* **Environment Variables**: Ensure all environment variables are correctly set for your specific environment.
* **Network Configuration**: Adjust network settings to avoid conflicts with existing services.
* **Volume Mounts**: Modify volume mounts to point to appropriate directories on your host system.
* **Resource Limits**: Review and adjust resource limits (CPU, memory) to align with your system capabilities.
* **Service Dependencies**: Ensure that all dependent services and databases are properly configured and accessible.

Failure to customize these files may lead to improper functioning of the application or conflicts within your environment. Please consult the documentation and seek assistance if needed to make the necessary adjustments.

By using this repository, you acknowledge that it is your responsibility to tailor the configuration to your environment. The maintainers of this repository are not liable for any issues arising from improper configuration.
