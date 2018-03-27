# The Lords

It is a browser turn-based strategy game for 2-4 players. Currently not deployed anywhere. Below is the developer's guide to set up development environment.

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
- Setup db with the next command `docker-compose exec db /database/bin/lords_db_init.sh`
- Add the lines below to you `/etc/hosts`:
```
# Lords
127.0.0.1 the-lords.org
127.0.0.1 ape-test.local
127.0.0.1 ape.the-lords.org
127.0.0.1 0.ape.the-lords.org
127.0.0.1 1.ape.the-lords.org
127.0.0.1 2.ape.the-lords.org
127.0.0.1 3.ape.the-lords.org
127.0.0.1 4.ape.the-lords.org
127.0.0.1 5.ape.the-lords.org
127.0.0.1 6.ape.the-lords.org
127.0.0.1 7.ape.the-lords.org
127.0.0.1 8.ape.the-lords.org
127.0.0.1 9.ape.the-lords.org
127.0.0.1 10.ape.the-lords.org
127.0.0.1 11.ape.the-lords.org
127.0.0.1 12.ape.the-lords.org
127.0.0.1 13.ape.the-lords.org
127.0.0.1 14.ape.the-lords.org
127.0.0.1 15.ape.the-lords.org
127.0.0.1 16.ape.the-lords.org
127.0.0.1 17.ape.the-lords.org
127.0.0.1 18.ape.the-lords.org
127.0.0.1 19.ape.the-lords.org
127.0.0.1 20.ape.the-lords.org
127.0.0.1 21.ape.the-lords.org
127.0.0.1 22.ape.the-lords.org
127.0.0.1 23.ape.the-lords.org
127.0.0.1 24.ape.the-lords.org
127.0.0.1 25.ape.the-lords.org
127.0.0.1 26.ape.the-lords.org
127.0.0.1 27.ape.the-lords.org
127.0.0.1 28.ape.the-lords.org
127.0.0.1 29.ape.the-lords.org
127.0.0.1 30.ape.the-lords.org
127.0.0.1 31.ape.the-lords.org
127.0.0.1 32.ape.the-lords.org
127.0.0.1 33.ape.the-lords.org
127.0.0.1 34.ape.the-lords.org
127.0.0.1 35.ape.the-lords.org
127.0.0.1 36.ape.the-lords.org
127.0.0.1 37.ape.the-lords.org
127.0.0.1 38.ape.the-lords.org
127.0.0.1 39.ape.the-lords.org
```
- Now you should have a running set of docker containers. Check all of them are working using `docker-compose ps` command. The game should be available via http://the-lords.org

Everyday Usage
---------------
- to launch containers run `docker-compose up -d`
- to stop containers run `docker-compose stop`
- to run command inside running container `docker exec web COMMAND`
- to login into container `docker-compose exec web /bin/bash`
- to run command in separate container instance `docker-compose run web COMMAND`
- to completely remove container `docker-compose kill web` + `docker-compose remove web` (it could be useful to recreate container when something went wrong).


You can change `web` to any container name, see `docker-compose.yml`.
Each container syncs required folders in both directions (see `docker-compose.yml` -> `volumes` sections).

Connecting to the database
---------------
To connect to the database running inside the docker container use TCP/IP connection localhost:3306 user:root, password:root

