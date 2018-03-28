#!/bin/bash

# Load env vars
echo -e "\x1B[01;93m export $(cat .env | xargs) \x1B[0m"
export $(cat .env | xargs)

# Push image to the local registry
echo -e "\x1B[01;93m --- PUSH IMAGE TO LOCAL REGISTRY --- \x1B[0m"
echo -e "\x1B[01;93m docker service create --name registry --publish published=5000,target=5000 registry:2 \x1B[0m"
docker service create --name registry --publish published=5000,target=5000 registry:2
echo -e "\x1B[01;93m docker-compose -f docker-compose.prod.yml build \x1B[0m"
docker-compose -f docker-compose.prod.yml build
echo -e "\x1B[01;93m docker-compose -f docker-compose.prod.yml push \x1B[0m"
docker-compose -f docker-compose.prod.yml push

# Deploy stack to swarm
echo -e "\x1B[01;93m --- DEPLOY DOCKER STACK --- \x1B[0m"
# Don't resolve image because ape uses i386 architecture
echo -e "\x1B[01;93m docker stack deploy --compose-file docker-compose.prod.yml --resolve-image=never lords \x1B[0m"
docker stack deploy --compose-file docker-compose.prod.yml --resolve-image=never lords

# Run migrations
echo -e "\x1B[01;93m --- RUN MIGRATIONS --- \x1B[0m"
# wait db service is updated for sure
echo -e '\x1B[01;93m Waiting db service to start... \x1B[0m'
COUNT=0
RESULT=""
until [[ $RESULT -eq "1/1" ]]
do
    sleep 5
    (( COUNT++ ))
    RESULT="$(docker service ls | grep db | awk '/ / { print $4 }')"
    if [[ $COUNT -eq 36 ]]; then # 3 minutes
        echo -e '\033[31m Deployment failed due to the timeout ... \033[0m'
        exit
    fi
done

# Run init only the first time
# docker exec -it $(docker ps -q -f name=lords_db) /database/bin/lords_db_init.sh
echo -e "\x1B[01;93m docker exec -it $(docker ps -q -f name=lords_db) /database/bin/lords_db_migrate.sh \x1B[0m"
docker exec -it $(docker ps -q -f name=lords_db) /database/bin/lords_db_migrate.sh

# Shut down registry
echo -e "\x1B[01;93m --- SHUT DOWN REGISTRY --- \x1B[0m"
echo -e "\x1B[01;93m docker service rm registry \x1B[0m"
docker service rm registry