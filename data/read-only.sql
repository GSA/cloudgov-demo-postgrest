-- All users are able to view tables and create object in the public schema. 
-- This change prevents the anonymous user from doing that.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public FROM anonymous;
