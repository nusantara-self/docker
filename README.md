# Compose files for TheHive

This repository publish Docker compose files that can be used to setup TheHive on a server for testing purpose, and ready for production purpose. 

# Requirements

* latest version of [Docker](https://www.docker.com/)

# Configuration

Each Compose file runs Elasticsearch, Cassandra and TheHive.

* *Elasticsearch* database and logs are stored in Docker volumes
* *Cassandra* database and logs are stored in Docker volumes
* *TheHive* configuration, attachments and logs files are stored in `./thehive` folder. 

# Usage

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


# Disclaimer

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