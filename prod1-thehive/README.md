# Single server deployment optimized for TheHive

## Requirements

Hardware requirements:
- At least 4 vCPUs dedicated to containers
- At least 16GB of RAM

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
