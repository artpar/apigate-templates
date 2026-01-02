#!/bin/bash
# Developer Tools API Gateway - Start Script
# Monetize DevOps APIs (GitHub, GitLab, npm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIGATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Set database path to this subproject's database
export APIGATE_DATABASE_DSN="$SCRIPT_DIR/apigate.db"

# Optional: Set API keys for upstream providers
# export GITHUB_TOKEN="ghp_your-token-here"
# export GITLAB_TOKEN="glpat-your-token-here"
# export NPM_TOKEN="npm_your-token-here"

# Server configuration
export APIGATE_SERVER_PORT="${PORT:-8080}"
export APIGATE_LOG_LEVEL="${LOG_LEVEL:-info}"

echo "=========================================="
echo "  Developer Tools API Gateway"
echo "  Monetize DevOps APIs"
echo "=========================================="
echo "Database: $APIGATE_DATABASE_DSN"
echo "Port: $APIGATE_SERVER_PORT"
echo ""

cd "$APIGATE_ROOT"
exec ./apigate serve
