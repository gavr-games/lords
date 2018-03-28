#!/bin/bash
echo -e "\x1B[01;93m --- UPDATE CODE --- \x1B[0m"
echo -e "\x1B[01;93m --- git pull --- \x1B[0m"
git pull

echo -e "\x1B[01;93m --- RUN DEPLOY --- \x1B[0m"
echo -e "\x1B[01;93m --- ./deployment/deploy_swarm.sh --- \x1B[0m"
./deployment/deploy_swarm.sh
