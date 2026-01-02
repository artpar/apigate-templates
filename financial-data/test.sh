#!/bin/bash
# Financial Data API Gateway - Test Script

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
echo "Financial Data API Gateway Test Suite"
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

# Stock API (Alpha Vantage)
echo ""
echo "2. Stock Data API (Alpha Vantage)"
if [ -n "$ALPHAVANTAGE_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Stock quote" "GET" "/v1/stocks/query?function=GLOBAL_QUOTE&symbol=IBM" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - ALPHAVANTAGE_API_KEY not configured"
fi

# Market API (Polygon)
echo ""
echo "3. Market Data API (Polygon)"
if [ -n "$POLYGON_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Ticker details" "GET" "/v1/market/v3/reference/tickers/AAPL" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - POLYGON_API_KEY not configured"
fi

# Crypto API (CoinGecko)
echo ""
echo "4. Crypto Data API (CoinGecko)"
if [ -n "$COINGECKO_API_KEY" ] || [ -n "$API_KEY" ]; then
    test_endpoint "Bitcoin price" "GET" "/v1/crypto/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" "200"
else
    echo -e "  ${YELLOW}SKIP${NC} - COINGECKO_API_KEY not configured"
fi

echo ""
echo "============================================"
echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
echo "============================================"

[ $FAILED -eq 0 ] && exit 0 || exit 1
