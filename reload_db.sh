#!/bin/sh
DB="mnn"
RAILS_ENV="development"
export RAILS_ENV="development"
LAST_RESTORE=`find ./backup -type f -name data_only_*.sql.gz | tail -n1`

echo "rake db:drop"
rake db:drop

echo "rake db:create"
rake db:create

echo "rake db:migrate"
rake db:migrate

echo "psql -d ${DB}_${RAILS_ENV} -a -f db/truncate.sql"
psql -d ${DB}_${RAILS_ENV} -a -f db/truncate.sql

echo "pg_restore -C -d ${DB}_${RAILS_ENV} ${LAST_RESTORE}"
pg_restore -C -d ${DB}_${RAILS_ENV} ${LAST_RESTORE}

echo "rake sunspot:reindex"
rake sunspot:reindex
