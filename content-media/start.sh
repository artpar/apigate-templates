#!/bin/bash
# Content & Media API Gateway - Start Script
# Monetize Content and Media APIs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIGATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Set database path to this subproject's database
export APIGATE_DATABASE_DSN="$SCRIPT_DIR/apigate.db"

# Optional: Set API keys for upstream providers
# export UNSPLASH_ACCESS_KEY="your-access-key"
# export PEXELS_API_KEY="your-api-key"
# export NEWSAPI_KEY="your-api-key"

# Server configuration
export APIGATE_SERVER_PORT="${PORT:-8080}"
export APIGATE_LOG_LEVEL="${LOG_LEVEL:-info}"

echo "=========================================="
echo "  Content & Media API Gateway"
echo "  Monetize Media APIs"
echo "=========================================="
echo "Database: $APIGATE_DATABASE_DSN"
echo "Port: $APIGATE_SERVER_PORT"
echo ""

cd "$APIGATE_ROOT"
exec ./apigate serve
