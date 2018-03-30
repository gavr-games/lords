#!/bin/bash

export $(cat .env | xargs)
tci d