#!/bin/bash
# LLM API Gateway - Start Script
# Monetize AI/LLM APIs (Anthropic, OpenAI, Gemini)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIGATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Set database path to this subproject's database
export APIGATE_DATABASE_DSN="$SCRIPT_DIR/apigate.db"

# Optional: Set API keys for upstream providers
# export ANTHROPIC_API_KEY="your-key-here"
# export OPENAI_API_KEY="your-key-here"
# export GEMINI_API_KEY="your-key-here"

# Server configuration
export APIGATE_SERVER_PORT="${PORT:-8080}"
export APIGATE_LOG_LEVEL="${LOG_LEVEL:-info}"

echo "=========================================="
echo "  LLM API Gateway"
echo "  Monetize AI/LLM APIs"
echo "=========================================="
echo "Database: $APIGATE_DATABASE_DSN"
echo "Port: $APIGATE_SERVER_PORT"
echo ""

cd "$APIGATE_ROOT"
exec ./apigate serve
