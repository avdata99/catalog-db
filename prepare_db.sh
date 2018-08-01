#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

psql -U $POSTGRES_USER -c "CREATE USER ${DB_CKAN_USER} WITH PASSWORD '${DB_CKAN_PASSWORD}' SUPERUSER;" && \
psql -U $POSTGRES_USER -c "CREATE DATABASE ${DB_CKAN_DB} OWNER ${DB_CKAN_USER};" && \
psql -U $POSTGRES_USER -d ckan -f /usr/share/postgresql/9.3/contrib/postgis-2.3/postgis.sql && \
psql -U $POSTGRES_USER -d ckan -f /usr/share/postgresql/9.3/contrib/postgis-2.3/spatial_ref_sys.sql && \
psql -U $POSTGRES_USER -d ckan -f /usr/share/postgresql/9.3/contrib/postgis-2.3/rtpostgis.sql && \
psql -U $POSTGRES_USER -d ckan -f /usr/share/postgresql/9.3/contrib/postgis-2.3/topology.sql && \
psql -U $POSTGRES_USER -d ckan -c "GRANT SELECT, UPDATE, INSERT, DELETE ON spatial_ref_sys TO ${DB_CKAN_USER};" && \
psql -U $POSTGRES_USER -c "SELECT 1 FROM pg_database WHERE datname = '${DB_PYCSW_DB}';" && \
psql -U $POSTGRES_USER -c "CREATE DATABASE ${DB_PYCSW_DB} OWNER ${DB_CKAN_USER};" && \
psql -U $POSTGRES_USER -d pycsw -c "CREATE EXTENSION postgis;"