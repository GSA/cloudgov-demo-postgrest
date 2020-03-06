#!/bin/bash

# Make sure we can find any installed python scripts
export PATH=$PATH:/home/vcap/deps/0/python/bin/

# If there's a csv/import.sh file, run it. Otherwise inspect, create tables, and import data from csv/*.csv
[ -x ./data/import.sh ] && ./data/import.sh || csvsql --db $DATABASE_URL --db-schema $DB_SCHEMA --insert data/*.csv

# Set up the anonymous and authenticator roles 
./setup-roles.py

# DB_URI=${DATABASE_URL} exec ./env-to-config ./postgrest postgrest.conf
