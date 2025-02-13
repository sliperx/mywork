#!/bin/bash
echo "host all all all trust" >> "$PGDATA/pg_hba.conf"
echo "host replication $PG_REP_USER $PG_REP_HOST trust" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';"
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
max_wal_senders = 8
hot_standby = on
#One chat takes up 50kb. If the load is 10,000 chats per hour, then chats take up 500mb. And 5gb should be enough for 10 hours
wal_keep_size = 5000

shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = 'all'
track_activity_query_size = '2048'
EOF