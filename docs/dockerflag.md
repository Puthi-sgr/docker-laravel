# Common Docker Command Flags

This document lists frequently used flags for `docker` and `docker-compose` commands.

## `docker run`

Flags used when creating and starting a new container from an image.

| Flag | Long Version | Description | Example |
| :--- | :--- | :--- | :--- |
| `-d` | `--detach` | Runs the container in the background (detached mode). | `docker run -d nginx` |
| `-p` | `--publish` | Maps a host port to a container port. Format: `host_port:container_port`. | `docker run -p 8080:80 nginx` |
| `-v` | `--volume` | Mounts a host path or named volume into the container. Format: `host_path:container_path`. | `docker run -v ./html:/usr/share/nginx/html nginx` |
| `-e` | `--env` | Sets an environment variable inside the container. | `docker run -e "ENV_VAR=value" my_app` |
| `--env-file` | | Reads and sets environment variables from a file. | `docker run --env-file ./.env my_app` |
| `--name` | | Assigns a custom name to the container. | `docker run --name my_web_server nginx` |
| `-it` | | Creates an interactive terminal session (combines `-i` for interactive and `-t` for TTY). | `docker run -it ubuntu bash` |
| `--rm` | | Automatically removes the container when it exits. | `docker run --rm hello-world` |
| `--network` | | Connects the container to a specific network. | `docker run --network my_network my_app` |

## `docker-compose`

Flags used with the `docker-compose` command to manage multi-container applications.

| Flag | Long Version | Description | Example |
| :--- | :--- | :--- | :--- |
| `-f` | `--file` | Specifies an alternate Compose file to use. | `docker-compose -f docker-compose.prod.yml up` |
| `--build` | | Forces `docker-compose` to build images before starting containers. | `docker-compose up --build` |
| `-d` | `--detach` | Runs services in the background. | `docker-compose up -d` |
| `--env-file` | | Specifies a custom path for an environment file. | `docker-compose --env-file ./.env.prod up` |

## `docker logs`

Flags for fetching logs from a container.

| Flag | Long Version | Description | Example |
| :--- | :--- | :--- | :--- |
| `-f` | `--follow` | Follows the log output in real-time. | `docker logs -f my_container` |
| `-t` | `--timestamps` | Shows timestamps for each log entry. | `docker logs -t my_container` |
| `--tail` | | Shows a specific number of lines from the end of the logs. | `docker logs --tail 100 my_container` |

## `docker exec`

Flags for executing a command inside a running container.

| Flag | Long Version | Description | Example |
| :--- | :--- | :--- | :--- |
| `-it` | | Creates an interactive terminal session for the command. | `docker exec -it my_container bash` |
| `-d` | `--detach` | Runs the command in the background inside the container. | `docker exec -d my_container ./long_running_script.sh` |

## `docker rm` / `docker rmi` / `docker network rm`

Flags for removing resources like containers, images, or networks.

| Flag | Long Version | Description | Example |
| :--- | :--- | :--- | :--- |
| `-f` | `--force` | Forces the removal of the resource (e.g., a running container). | `docker rm -f my_container` |