#!/bin/bash

DUMP_DIR=/database/dump
BASELINE_NAME=00_baseline.sql
BIN_DIR=/database/bin
INCREMENTAL_UPDATES_DIR=/database/incremental_updates

echo Initializing DB
$BIN_DIR/lords_db_init.sh

echo Making dump
$BIN_DIR/create_dump.sh $BASELINE_NAME

echo Removing old incremental updates
rm $INCREMENTAL_UPDATES_DIR/*

echo Moving new baseline
mv $DUMP_DIR/$BASELINE_NAME $INCREMENTAL_UPDATES_DIR

echo "Baseline reset done"

