if [ "$(ls -A /var/lib/postgresql/data)" ]; then
   echo "not empty";
else
   pg_basebackup -P -R -X stream -c fast -h postgresdb-master -U $PG_REP_USER -D /var/lib/postgresql/data --no-password;
fi
if [ "$(ls -A /var/lib/postgresql/data/standby.signal)" ]; then
   echo "replica";
else
   rm -r /var/lib/postgresql/data/*;
   pg_basebackup -P -R -X stream -c fast -h postgresdb-master -U $PG_REP_USER -D /var/lib/postgresql/data --no-password;
fi
