#!/bin/bash
# Financial Data API Gateway - Start Script
# Monetize market data APIs (Alpha Vantage, Polygon, CoinGecko)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIGATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Set database path to this subproject's database
export APIGATE_DATABASE_DSN="$SCRIPT_DIR/apigate.db"

# Optional: Set API keys for upstream providers
# export ALPHAVANTAGE_API_KEY="your-key-here"
# export POLYGON_API_KEY="your-key-here"
# export COINGECKO_API_KEY="your-key-here"

# Server configuration
export APIGATE_SERVER_PORT="${PORT:-8080}"
export APIGATE_LOG_LEVEL="${LOG_LEVEL:-info}"

echo "=========================================="
echo "  Financial Data API Gateway"
echo "  Monetize Market Data APIs"
echo "=========================================="
echo "Database: $APIGATE_DATABASE_DSN"
echo "Port: $APIGATE_SERVER_PORT"
echo ""

cd "$APIGATE_ROOT"
exec ./apigate serve
