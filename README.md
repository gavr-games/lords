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
- cd to project's root folder and run `docker-compose build`. It will build all Dockerfiles and create images for containers.
- run `docker-compose up -d` to start all services.
- Setup db with the next command `docker-compose exec db /database/bin/lords_db_init.sh`

Other
---------------
