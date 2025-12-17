#!/bin/bash

# Validate action parameter
ACTION=$1
VALID_ACTIONS=("up" "down" "restart" "logs" "ps" "build" "clean")

if [[ ! " ${VALID_ACTIONS[@]} " =~ " ${ACTION} " ]]; then
  echo "Usage: $0 {up|down|restart|logs|ps|build|clean}"
  exit 1
fi

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_ROOT"

# Load context.json and get active clients
ACTIVE_CLIENTS=$(jq -r '.clients | to_entries[] | select(.value.active == true) | .value.compose' context.json)

# Build compose file list
COMPOSE_FILES="-f docker-compose.yml"
while IFS= read -r compose_file; do
  COMPOSE_FILES="$COMPOSE_FILES -f docker/$compose_file"
done <<< "$ACTIVE_CLIENTS"

# Action to command mapping
case $ACTION in
  up)      CMD="up -d" ;;
  down)    CMD="down" ;;
  restart) CMD="restart" ;;
  logs)    CMD="logs -f" ;;
  ps)      CMD="ps" ;;
  build)   CMD="build" ;;
  clean)   CMD="down -v" ;;
esac

# Execute
docker compose $COMPOSE_FILES $CMD
