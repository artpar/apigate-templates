#!/bin/bash
# LLM API Gateway - Test Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_URL="${APIGATE_URL:-http://localhost:8080}"
API_KEY="${API_KEY:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0

test_endpoint() {
    local name="$1"
    local method="$2"
    local endpoint="$3"
    local expected_status="$4"
    local data="$5"

    if [ -z "$API_KEY" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - No API_KEY set"
        return
    fi

    if [ "$method" = "POST" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST \
            -H "X-API-Key: $API_KEY" \
            -H "Content-Type: application/json" \
            -d "$data" \
            --max-time 30 \
            "${BASE_URL}${endpoint}")
    else
        response=$(curl -s -w "\n%{http_code}" \
            -H "X-API-Key: $API_KEY" \
            --max-time 10 \
            "${BASE_URL}${endpoint}")
    fi

    status=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$status" = "$expected_status" ]; then
        echo -e "  ${GREEN}PASS${NC} $name (HTTP $status)"
        ((PASSED++))
    else
        echo -e "  ${RED}FAIL${NC} $name (Expected $expected_status, got $status)"
        echo "    Response: ${body:0:100}..."
        ((FAILED++))
    fi
}

echo "============================================"
echo "LLM API Gateway Test Suite"
echo "============================================"
echo "Base URL: $BASE_URL"
echo ""

# Health check
echo "1. Health Check"
health=$(curl -s "${BASE_URL}/health")
if echo "$health" | grep -q "ok"; then
    echo -e "  ${GREEN}PASS${NC} Health endpoint"
    ((PASSED++))
else
    echo -e "  ${RED}FAIL${NC} Health endpoint"
    ((FAILED++))
fi

# Anthropic API
echo ""
echo "2. Anthropic API (Claude)"
if [ -n "$ANTHROPIC_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Chat completion" "POST" "/v1/anthropic/messages" "200" \
        '{"model":"claude-sonnet-4-20250514","max_tokens":50,"stream":false,"messages":[{"role":"user","content":"Say hi in 5 words"}]}'
else
    echo -e "  ${YELLOW}SKIP${NC} - ANTHROPIC_API_KEY not configured"
fi

# OpenAI API
echo ""
echo "3. OpenAI API (GPT)"
if [ -n "$OPENAI_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Chat completion" "POST" "/v1/openai/chat/completions" "200" \
        '{"model":"gpt-4o-mini","max_tokens":50,"messages":[{"role":"user","content":"Say hi"}]}'
else
    echo -e "  ${YELLOW}SKIP${NC} - OPENAI_API_KEY not configured"
fi

# Gemini API
echo ""
echo "4. Gemini API"
if [ -n "$GEMINI_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Generate content" "POST" "/v1/gemini/v1beta/models/gemini-2.0-flash:generateContent" "200" \
        '{"contents":[{"parts":[{"text":"Say hi"}]}]}'
else
    echo -e "  ${YELLOW}SKIP${NC} - GEMINI_API_KEY not configured"
fi

echo ""
echo "============================================"
echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
echo "============================================"

[ $FAILED -eq 0 ] && exit 0 || exit 1
