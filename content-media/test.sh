#!/bin/bash
# Content & Media API Gateway - Test Script

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

    if [ -z "$API_KEY" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - No API_KEY set"
        return
    fi

    response=$(curl -s -w "\n%{http_code}" \
        -H "X-API-Key: $API_KEY" \
        --max-time 10 \
        "${BASE_URL}${endpoint}")

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
echo "Content & Media API Gateway Test Suite"
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

# Unsplash API
echo ""
echo "2. Unsplash API (Stock Photos)"
if [ -n "$UNSPLASH_ACCESS_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Photo search" "GET" "/v1/photos/search?query=test" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - UNSPLASH_ACCESS_KEY not configured"
fi

# Pexels API
echo ""
echo "3. Pexels API (Photos/Videos)"
if [ -n "$PEXELS_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Media search" "GET" "/v1/media/v1/search?query=test" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - PEXELS_API_KEY not configured"
fi

# NewsAPI
echo ""
echo "4. NewsAPI (News Articles)"
if [ -n "$NEWSAPI_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Top headlines" "GET" "/v1/news/v2/top-headlines?country=us" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - NEWSAPI_KEY not configured"
fi

echo ""
echo "============================================"
echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
echo "============================================"

[ $FAILED -eq 0 ] && exit 0 || exit 1
