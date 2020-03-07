#!/bin/bash

set -e

# Make sure we can find any installed python scripts
export PATH=$PATH:/home/vcap/deps/0/python/bin/

# If there's a csv/import.sh file, run it. Otherwise inspect, create tables, and import data from csv/*.csv
# We only do this when the first instance comes up; no need for every instance to do it.
[[ $CF_INSTANCE_INDEX -eq 0 && -x ./data/init.sh ]] && ./data/init.sh 

export DB_URI=${DATABASE_URL}
exec ./env-to-config ./postgrest postgrest.conf
