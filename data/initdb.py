#!/usr/bin/python

# Does initial setup on the database to make it ready for postgREST.
# Expects to read DATABASE_URL, DB_SCHEMA, and DB_ANON_ROLE from the environment.
# 
# This script also provides a way to make DB queries without the `psql` client available:
# At the appropriate time, it runs the content of any passed arguments as files full of SQL queries.

import os
import sys
import glob
import psycopg2

try:
    conn=psycopg2.connect(os.environ['DATABASE_URL'])
except:
    print "Unable to connect to database"
    sys.exit(-1)

# Do the database setup

# Create the schema
with conn, conn.cursor() as cur:
    cur.execute('CREATE SCHEMA IF NOT EXISTS ' + os.environ['DB_SCHEMA'])

try:
    with conn, conn.cursor() as cur:
        # Create a read-only role to be used for any unauthenticated user
        cur.execute('CREATE ROLE ' + os.environ['DB_ANON_ROLE'])

        # The anonymous role can use this schema
        cur.execute('GRANT USAGE ON SCHEMA ' + os.environ['DB_SCHEMA'] + ' TO ' + os.environ['DB_ANON_ROLE'])

        # The anonymous role will have read-only access to data in all the tables in this schema by default
        cur.execute('ALTER DEFAULT PRIVILEGES IN SCHEMA ' + os.environ['DB_SCHEMA'] + ' GRANT SELECT ON TABLES TO ' + os.environ['DB_ANON_ROLE'])

        # Enable the PostgREST user to assume the anonymous role
        cur.execute('GRANT ' + os.environ['DB_ANON_ROLE'] + ' TO ' + os.environ['DB_USERNAME'])

except psycopg2.DatabaseError as error:
    print "WARNING: Unable to set up the anonymous role " + os.environ['DB_ANON_ROLE']
    print "If you're using shared-psql, try upgrading to the medium-psql plan! Details:"
    print(error)

# Invoke the init.sh file to load data into the schema
# We do this here so that subsequent SQL files can alter permissions, do things with the data, etc.
os.system('data/initdata.sh')

# Run any provided SQL files in alphabetical order
for sqlfile in sorted(glob.glob("data/*.sql")):
    print 'Running file: ' + sqlfile
    try:
        with conn, conn.cursor() as cur:
            # Ensure queries are executed in the context of the schema
            cur.execute('SET search_path TO ' + os.environ['DB_SCHEMA'])
            cur.execute(open(sqlfile, "r").read())
    except psycopg2.DatabaseError as error:
        print(error)
