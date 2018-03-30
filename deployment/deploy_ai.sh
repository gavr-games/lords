#!/bin/bash

killall java

cd /tmp

rm -r ai
mkdir ai

rm -r ai_bin
mkdir ai_bin

cp -R /ai /tmp

javac -cp ./ai/lib/json-simple-1.1.1.jar:./ai_bin -d ./ai_bin ./ai/src/ai/paths_finding/astar/*.java
javac -cp ./ai/lib/json-simple-1.1.1.jar:./ai_bin -d ./ai_bin ./ai/src/ai/paths_finding/jump_point_search/*.java
javac -cp ./ai/lib/json-simple-1.1.1.jar:./ai_bin -d ./ai_bin ./ai/src/ai/paths_finding/*.java
javac -cp ./ai/lib/json-simple-1.1.1.jar:./ai_bin -d ./ai_bin ./ai/src/ai/*.java

# Blocking call to java to keep docker container running
java -cp ./ai_bin:./ai/lib/json-simple-1.1.1.jar -Djava.util.logging.config.file=./ai/logging.properties ai.AiServicePublisher

