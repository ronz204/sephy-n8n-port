
-- Create laboratory user if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '${LABORATORY_USER}') THEN
    CREATE USER ${LABORATORY_USER} WITH PASSWORD '${LABORATORY_PASSWORD}';
  END IF;
END
$$;

-- Create laboratory database if it doesn't exist
SELECT 'CREATE DATABASE ${LABORATORY_DB} OWNER ${LABORATORY_USER}'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${LABORATORY_DB}')\gexec

-- Grant all privileges to the laboratory user
GRANT ALL PRIVILEGES ON DATABASE ${LABORATORY_DB} TO ${LABORATORY_USER};
