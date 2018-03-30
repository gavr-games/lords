# The Lords

It is a browser turn-based strategy game for 2-4 players available at <http://lords.world>. Below is the developer's guide to set up development environment.

Getting Started
---------------

The general idea is to have a set of containers with Lords services installed and working inside of it. Any developer will be able to quickly bring it up and test/develop.
We use Docker and Docker Compose to spin up our development environment.
You can [install Docker here](https://docs.docker.com/engine/installation/linux/ubuntu/)
You will also need to [install Docker Compose](https://docs.docker.com/compose/install/)

Pre Requirements
---------------

- Your machine should support virtualization. Sometimes you need to enable it in BIOS.
- OS: Ubuntu or MacOS.
- Installed Docker + Docker Compose.
- Internet connection :)

Next steps
---------------

Once you have all of those installed you should:
- Checkout latest Lords code from GitHub. You should see `docker-compose.yml` file in the root defining all services.
- create `.env` file from `.env.example`
- cd to project's root folder and run `docker-compose build`. It will build all Dockerfiles and create images for containers.
- run `docker-compose up -d` to start all services.
- Setup db with the following command `docker-compose exec db /database/bin/lords_db_init.sh`
- Add the lines below to your `/etc/hosts` (domain name `lords.local` is specified in `.env`):
```
# Lords
127.0.0.1 lords.local
127.0.0.1 ape.lords.local
127.0.0.1 0.ape.lords.local
127.0.0.1 1.ape.lords.local
127.0.0.1 2.ape.lords.local
127.0.0.1 3.ape.lords.local
127.0.0.1 4.ape.lords.local
127.0.0.1 5.ape.lords.local
127.0.0.1 6.ape.lords.local
127.0.0.1 7.ape.lords.local
127.0.0.1 8.ape.lords.local
127.0.0.1 9.ape.lords.local
127.0.0.1 10.ape.lords.local
127.0.0.1 11.ape.lords.local
127.0.0.1 12.ape.lords.local
127.0.0.1 13.ape.lords.local
127.0.0.1 14.ape.lords.local
127.0.0.1 15.ape.lords.local
127.0.0.1 16.ape.lords.local
127.0.0.1 17.ape.lords.local
127.0.0.1 18.ape.lords.local
127.0.0.1 19.ape.lords.local
127.0.0.1 20.ape.lords.local
127.0.0.1 21.ape.lords.local
127.0.0.1 22.ape.lords.local
127.0.0.1 23.ape.lords.local
127.0.0.1 24.ape.lords.local
127.0.0.1 25.ape.lords.local
127.0.0.1 26.ape.lords.local
127.0.0.1 27.ape.lords.local
127.0.0.1 28.ape.lords.local
127.0.0.1 29.ape.lords.local
127.0.0.1 30.ape.lords.local
127.0.0.1 31.ape.lords.local
127.0.0.1 32.ape.lords.local
127.0.0.1 33.ape.lords.local
127.0.0.1 34.ape.lords.local
127.0.0.1 35.ape.lords.local
127.0.0.1 36.ape.lords.local
127.0.0.1 37.ape.lords.local
127.0.0.1 38.ape.lords.local
127.0.0.1 39.ape.lords.local
```
- Now you should have a running set of docker containers. Check all of them are working using `docker-compose ps` command. The game should be available via http://lords.local

Everyday Usage
---------------
- to launch containers run `docker-compose up -d`
- to stop containers run `docker-compose stop`
- to run command inside running container `docker exec web COMMAND`
- to login into container `docker-compose exec web /bin/bash`
- to run command in separate container instance `docker-compose run web COMMAND`
- to completely remove container `docker-compose kill web` + `docker-compose rm web` (it could be useful to recreate container when something went wrong).


You can change `web` to any container name, see `docker-compose.yml`.
Each container syncs required folders in both directions (see `docker-compose.yml` -> `volumes` sections).

Connecting to the database
---------------
To connect to the database running inside the docker container use TCP/IP connection localhost:3306 user:root, password:root (password specified in `.env`)

Deploy
---------------
- install Docker and Docker Compose
- install [tci](https://github.com/sergey-koba-mobidev/tci/releases/tag/latest)
- clone code
- create `.env` file
- create `log` directory
- add permissions for lang cache `chmod 0777 web/lang/cache`
- run `./deployment/deploy.sh`

Validate deployed services:
- `docker stack services lords` - replicas should be 1/1, not 0/1
- rum database updates `docker exec -it $(docker ps -q -f name=lords_db) /database/bin/lords_db_update.sh`
- see the list of containers with errors `docker stack ps lords --no-trunc`


