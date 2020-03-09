#!/bin/bash

set -e

# Make sure we can find any installed python scripts
export PATH=$PATH:/home/vcap/deps/0/python/bin/

# Set DB_USERNAME, which is used when granting access to the anonymous role
[[ $DATABASE_URL =~ (.*)'://'(.*):(.*)@(.*):(.*?)/(.*) ]] && export DB_USERNAME=${BASH_REMATCH[2]}

# Initialize the database and its content
# We only do this when the first instance comes up; no need for every instance to do it!
[[ $CF_INSTANCE_INDEX -eq 0 && -x ./data/initdb.py ]] && ./data/initdb.py 

export DB_URI=${DATABASE_URL}
exec ./env-to-config ./postgrest postgrest.conf
