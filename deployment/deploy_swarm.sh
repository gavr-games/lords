#!/bin/bash

export $(cat .env | xargs)
export REVISION=$(git rev-parse --short HEAD)
tci d

