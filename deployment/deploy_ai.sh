#!/bin/bash

killall java

cd /tmp

rm -r ai
mkdir ai

rm -r ai_bin
mkdir ai_bin

cp -R /ai /tmp

javac -cp ./ai/lib/json-simple-1.1.1.jar:./ai/src -d ./ai_bin ./ai/src/ai/service/AiServicePublisher.java

# Blocking call to java to keep docker container running
java -cp ./ai_bin:./ai/lib/json-simple-1.1.1.jar -Djava.util.logging.config.file=./ai/logging.properties ai.service.AiServicePublisher

