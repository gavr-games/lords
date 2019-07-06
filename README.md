# The Lords

It is a browser turn-based strategy game for 2-4 players available at <https://gavr.games>. Below is the developer's guide to set up development environment.

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
- run `chmod o+w ./web/lang/cache` to give write rights to the containers.
- cd to project's root folder and run `docker-compose build`. It will build all Dockerfiles and create images for containers.
- run `docker-compose up -d` to start all services.
- Setup db with the following command `docker-compose exec db /database/bin/lords_db_init.sh`
- Install npm packages for ui `docker-compose run --rm ui npm install`. Remember you might need to run this after `git pull` too.
- Add the lines below to your `/etc/hosts` (domain name `lords.local` is specified in `.env`):
```
# Lords
127.0.0.1 lords.local
```
- Now you should have a running set of docker containers. Check all of them are working using `docker-compose ps` command. The game should be available via http://lords.local

Everyday Usage
---------------
- to launch containers run `docker-compose up -d`
- to stop containers run `docker-compose stop`
- to run command inside running container `docker exec api COMMAND`
- to login into container `docker-compose exec api /bin/bash`
- to run command in separate container instance `docker-compose run --rm api COMMAND`
- to completely remove container `docker-compose kill api` + `docker-compose rm api` (it could be useful to recreate container when something went wrong).

You can change `api` to any container name, see `docker-compose.yml`.
Each container syncs required folders in both directions (see `docker-compose.yml` -> `volumes` sections).

Generate static JS libs
---------------
- `dc run --rm api sh -c "cd cron &&  php ./generate_static_js_libs.php"`
- `dc run --rm api sh -c "cd cron &&  php ./generate_static_js_libs_site.php"`

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
- make sure `web/game/mode9` is writable for everyone for error saving

Validate deployed services:
- `docker stack services lords` - replicas should be 1/1, not 0/1
- run database updates `docker exec -it $(docker ps -q -f name=lords_db) /database/bin/lords_db_update.sh`
- see the list of containers with errors `docker stack ps lords --no-trunc`
- see service logs `docker service logs --tail="200" lords_ws` replace ws with service name

