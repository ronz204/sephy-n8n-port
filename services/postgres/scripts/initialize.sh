#!/bin/bash
set -e

# Iterate over all SQL files in the clients directory
for sql_file in /docker-entrypoint-initdb.d/clients/*.sql; do
  if [ -f "$sql_file" ]; then
    # Expand environment variables and execute SQL file
    envsubst < "$sql_file" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
  fi
done

echo "Database initialization completed"
