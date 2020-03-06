#!/bin/bash

# Get the binary for the latest version of PostgREST
curl -L `curl https://api.github.com/repos/postgrest/postgrest/releases/latest 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("ubuntu.tar")) | .browser_download_url' ` | tar xzv

# Get a script that will map env vars to a postgrest.conf file and then run the binary
curl https://raw.githubusercontent.com/PostgREST/postgrest-heroku/master/env-to-config > env-to-config

# Make both files executable
chmod +x postgrest env-to-config

# Create a database service
# (NOTE: This is the default name; change it if you edit the vars.yml app_name default!)
# (NOTE: If you want a DB where you can create explicit roles, don't use the shared plan!)
cf create-service aws-rds shared-psql postgrest-db

# Push the application up; this will error until you copy vars.yml.template to vars.yml!
cf push --vars-file vars.yml

