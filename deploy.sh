#!/bin/bash

# Stop processing if anything goes wrong
set -e

# Get the binary for the latest version of PostgREST
curl -L `curl -s https://api.github.com/repos/postgrest/postgrest/releases/latest 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("ubuntu.tar")) | .browser_download_url' ` | tar xzv

# Get a convenient script that maps env vars to a postgrest.conf file and then runs the binary
curl https://raw.githubusercontent.com/PostgREST/postgrest-heroku/master/env-to-config > env-to-config

# Make both files executable
chmod +x postgrest env-to-config

# Create a database service
# (NOTE: postgrest-db is the *default* name; if you edit the app_name in vars.yml change this to match!)
# (NOTE: If you want a REST API with access control, use the medium-psql plan or better!)
cf create-service aws-rds medium-psql postgrest-db

# Wait until the DB service is both available and ready for use
# See https://cloud.gov/docs/services/relational-database/#instance-creation-time
until cf create-service-key postgrest-db ready-yet > /dev/null 2>&1
do 
    echo "Waiting for the database to spin up..."
    sleep 10
done

# Delete the canary key since it's no longer needed
cf delete-service-key -f postgrest-db ready-yet > /dev/null 2>&1

# Push the application up; this will error until you copy vars.yml.template to vars.yml!
[[ -e vars.yml ]] \
    && cf push --vars-file vars.yml \
    || echo "vars.yml not found; copy and optionally customize vars.yml.template!"

