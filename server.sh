#!/usr/bin/env bash
# Start/stop the full Enshrouded + Pelican stack.
# Usage: ./server.sh {start|stop|restart|status}

set -euo pipefail

cd "$(dirname "$0")"
COMPOSE="docker compose -f enshrouded-server.compose.yaml"
GAME_CONTAINER="4b2c1cc0-e00e-42c5-9e5e-c44dddf99fa4"

case "${1:-}" in
  start)
    echo "Starting Pelican stack..."
    $COMPOSE up -d
    echo "Waiting for Wings to come up..."
    sleep 5
    if docker ps -a --format '{{.Names}}' | grep -q "^${GAME_CONTAINER}$"; then
      echo "Starting Enshrouded server container..."
      docker start "$GAME_CONTAINER" >/dev/null 2>&1 || true
    fi
    echo "Done. Panel: https://pelican.blueboxcars.dev"
    ;;
  stop)
    echo "Stopping Enshrouded server (saving world)..."
    if docker ps --format '{{.Names}}' | grep -q "^${GAME_CONTAINER}$"; then
      docker stop -t 120 "$GAME_CONTAINER" >/dev/null 2>&1 || true
    fi
    echo "Stopping Pelican stack..."
    $COMPOSE down
    echo "Done."
    ;;
  restart)
    "$0" stop
    "$0" start
    ;;
  status)
    echo "=== Pelican stack ==="
    $COMPOSE ps
    echo ""
    echo "=== Enshrouded server ==="
    if docker ps -a --format '{{.Names}}' | grep -q "^${GAME_CONTAINER}$"; then
      docker ps --filter "name=${GAME_CONTAINER}" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    else
      echo "No game server container found."
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac