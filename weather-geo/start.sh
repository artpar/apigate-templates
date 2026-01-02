#!/bin/bash
# Weather & Geo API Gateway - Start Script
# Monetize Weather and Location APIs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIGATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Set database path to this subproject's database
export APIGATE_DATABASE_DSN="$SCRIPT_DIR/apigate.db"

# Optional: Set API keys for upstream providers
# export OPENWEATHERMAP_API_KEY="your-api-key"
# export MAPBOX_ACCESS_TOKEN="your-access-token"
# export IPINFO_TOKEN="your-token"

# Server configuration
export APIGATE_SERVER_PORT="${PORT:-8080}"
export APIGATE_LOG_LEVEL="${LOG_LEVEL:-info}"

echo "=========================================="
echo "  Weather & Geo API Gateway"
echo "  Monetize Location Services"
echo "=========================================="
echo "Database: $APIGATE_DATABASE_DSN"
echo "Port: $APIGATE_SERVER_PORT"
echo ""

cd "$APIGATE_ROOT"
exec ./apigate serve
