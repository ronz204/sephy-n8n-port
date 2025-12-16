FROM postgres:15-alpine

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Copy and configure health check script
COPY scripts/healthy.sh /healthy.sh
RUN chmod +x /healthy.sh

# Copy initialization script (runs on container startup)
COPY scripts/initialize.sh /docker-entrypoint-initdb.d/00-initialize.sh
RUN chmod +x /docker-entrypoint-initdb.d/00-initialize.sh

# Copy SQL files for database and user creation
COPY clients /docker-entrypoint-initdb.d/clients
