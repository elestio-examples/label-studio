<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Label Studio, verified and packaged by Elestio

[Label Studio](https://labelstud.io) is a multi-type data labeling and annotation tool with standardized output format
<img src="https://github.com/elestio-examples/label-studio/raw/main/label-studio.gif" alt="label-studio" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/label-studio">fully managed Label Studio</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/label-studio/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/label-studio)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/label-studio.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following commands

    ./scripts/preInstall.sh
    docker-compose up -d
    ./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:62774`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.9"
    services:
        nginx:
            image: elestio4test/label-studio:${SOFTWARE_VERSION_TAG}
            restart: always
            ports:
                - "172.17.0.1:62774:8085"
            depends_on:
                - app
            environment:
                - LABEL_STUDIO_HOST=${LABEL_STUDIO_HOST}
                #   Optional: Specify SSL termination certificate & key
                #   Just drop your cert.pem and cert.key into folder 'deploy/nginx/certs'
                #      - NGINX_SSL_CERT=/certs/cert.pem
                #      - NGINX_SSL_CERT_KEY=/certs/cert.key
            volumes:
                - ./mydata:/label-studio/data:rw
                - ./deploy/nginx/certs:/certs:ro
                #   Optional: Override nginx default conf
                #      - ./deploy/my.conf:/etc/nginx/nginx.conf
            command: nginx

        app:
            stdin_open: true
            tty: true
            image: elestio4test/label-studio:${SOFTWARE_VERSION_TAG}
            restart: always
            expose:
                - "8000"
            depends_on:
                - db
            environment:
                - DJANGO_DB=default
                - POSTGRE_NAME=${POSTGRES_DB}
                - POSTGRE_USER=${POSTGRES_USER}
                - POSTGRE_PASSWORD=${POSTGRES_PASSWORD}
                - POSTGRE_PORT=${POSTGRE_PORT}
                - POSTGRE_HOST=${POSTGRE_HOST}
                - LABEL_STUDIO_HOST=${LABEL_STUDIO_HOST}
                - JSON_LOG=1
                #      - LOG_LEVEL=DEBUG
            volumes:
                - ./mydata:/label-studio/data:rw
            command: label-studio-uwsgi

        db:
            image: elestio/postgres:15
            hostname: db
            restart: always
            ports:
                - 172.17.0.1:58194:5432
                # Optional: Enable TLS on PostgreSQL
                # Just drop your server.crt and server.key into folder 'deploy/pgsql/certs'
                # NOTE: Both files must have permissions u=rw (0600) or less
                #    command: >
                #      -c ssl=on
                #      -c ssl_cert_file=/var/lib/postgresql/certs/server.crt
                #      -c ssl_key_file=/var/lib/postgresql/certs/server.key
            environment:
                - POSTGRES_DB=${POSTGRES_DB}
                - POSTGRES_USER=${POSTGRES_USER}
                - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
            volumes:
                - ./postgres-data:/var/lib/postgresql/data
                # - ./deploy/pgsql/certs:/var/lib/postgresql/certs:ro

        pgadmin4:
            image: elestio/pgadmin:latest
            restart: always
            environment:
                PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
                PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
                PGADMIN_LISTEN_PORT: 8080
            ports:
                - "172.17.0.1:30954:8080"
            volumes:
                - ./servers.json:/pgadmin4/servers.json

### Environment variables

|       Variable       |   Value (example)   |
| :------------------: | :-----------------: |
| SOFTWARE_VERSION_TAG |       latest        |
|    ADMIN_PASSWORD    |    your-password    |
|     ADMIN_EMAIL      |   your@email.com    |
|  LABEL_STUDIO_HOST   | https://your.domain |
|     DOMAIN_NAME      |     your.domain     |
|     POSTGRES_DB      |    label_studio     |
|    POSTGRES_USER     |      postgres       |
|  POSTGRES_PASSWORD   |    your-password    |
|     POSTGRE_PORT     |        5432         |
|     POSTGRE_HOST     |         db          |

# Maintenance

## Logging

The Elestio Label Studio Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/HumanSignal/label-studio">Label Studio Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/label-studio">Elestio/Label Studio Github repository</a>
