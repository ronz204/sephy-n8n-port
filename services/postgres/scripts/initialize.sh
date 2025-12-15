#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- Crear usuario n8n si no existe
  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '${N8N_USER}') THEN
      CREATE USER ${N8N_USER} WITH PASSWORD '${N8N_PASSWORD}';
    END IF;
  END
  \$\$;

  -- Crear base de datos n8n_db
  SELECT 'CREATE DATABASE ${N8N_DB} OWNER ${N8N_USER}'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${N8N_DB}')\gexec

  -- Otorgar privilegios
  GRANT ALL PRIVILEGES ON DATABASE ${N8N_DB} TO ${N8N_USER};
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- Crear usuario alpha si no existe
  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '${ALPHA_USER}') THEN
      CREATE USER ${ALPHA_USER} WITH PASSWORD '${ALPHA_PASSWORD}';
    END IF;
  END
  \$\$;

  -- Crear base de datos alpha_db
  SELECT 'CREATE DATABASE ${ALPHA_DB} OWNER ${ALPHA_USER}'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${ALPHA_DB}')\gexec

  -- Otorgar privilegios
  GRANT ALL PRIVILEGES ON DATABASE ${ALPHA_DB} TO ${ALPHA_USER};
EOSQL

echo "✓ Bases de datos y usuarios creados exitosamente:"
echo "  - Usuario: ${N8N_USER} | Base de datos: ${N8N_DB}"
echo "  - Usuario: ${ALPHA_USER} | Base de datos: ${ALPHA_DB}"