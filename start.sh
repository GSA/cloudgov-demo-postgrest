#!/bin/bash

set -e

# Make sure we can find any installed python scripts
export PATH=$PATH:/home/vcap/deps/0/python/bin/

# If there's a csv/import.sh file, run it. Otherwise inspect, create tables, and import data from csv/*.csv
[ -x ./data/init.sh ] && ./data/init.sh 

# TODO: Set up explicit anonymous and authenticator roles 
#   ./setup-roles.py
# For now, let's just use the role that the platform gave us
[[ $DATABASE_URL =~ (.*)'://'(.*):(.*)@(.*):(.*?)/(.*) ]] && export DB_ANON_ROLE=${BASH_REMATCH[2]}

export DB_URI=${DATABASE_URL}
exec ./env-to-config ./postgrest postgrest.conf
