#!/usr/bin/python

# An easy way to make DB queries without the `psql` client available.
# Just connects to the $DATABASE_URL and runs the content of any passed arguments as SQL

import os
import psycopg2
import sys

try:
    conn=psycopg2.connect(os.environ['DATABASE_URL'])
except:
    print "Unable to connect to database"
    sys.exit(-1)

cur = conn.cursor()

for sqlfile in sorted(sys.argv[1:]):
    print 'Running ' + sqlfile
    try:
        cur.execute(open(sqlfile, "r").read())
    except:
        print 'Got exception running file ' + sqlfile

