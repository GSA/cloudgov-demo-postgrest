#!/usr/bin/python

# Does initial setup on the database to make it ready for postgREST.
# Expects to read DATABASE_URL, DB_SCHEMA, and DB_ANON_ROLE from the environment.
# 
# This script also provides a way to make DB queries without the `psql` client available.
# It runs the content of any passed arguments as files full of SQL queries.

import os
import psycopg2
import sys

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
        cur.execute('GRANT USAGE ON SCHEMA ' + os.environ['DB_SCHEMA'] + ' TO ' + os.environ['DB_ANON_ROLE'])
        cur.execute('REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA ' + os.environ['DB_SCHEMA'] + ' FROM ' + os.environ['DB_ANON_ROLE'])

        # Enable the connecting user to assume the anonymous role
        cur.execute('GRANT ' + os.environ['DB_ANON_ROLE'] + ' TO ' + os.environ['DB_USERNAME'])

except:
    print "WARNING: Unable to create role " + os.environ['DB_ANON_ROLE']
    print "If you're using shared-psql, try upgrading to the medium-psql plan!"

# Run any provided SQL files in alphabetical order
for sqlfile in sorted(sys.argv[1:]):
    print 'Running ' + sqlfile
    try:
        with conn, conn.cursor() as cur:
            cur.execute(open(sqlfile, "r").read())
    except:
        print 'Got exception running file ' + sqlfile


