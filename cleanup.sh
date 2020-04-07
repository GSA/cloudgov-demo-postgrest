#!/bin/bash

# Nukes the app and db created using the default values
cf delete -f -r postgrest
cf delete-service-key -f postgrest-db ready-yet
cf delete-service -f postgrest-db
