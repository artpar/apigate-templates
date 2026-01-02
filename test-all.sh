#!/bin/bash
# APIGate Subprojects - Master Test Script
# Tests all subproject deployments

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "============================================"
echo "  APIGate Subprojects - Master Test Suite"
echo "============================================"
echo ""

SUBPROJECTS=(
    "llm-gateway:LLM API Gateway:8081"
    "financial-data:Financial Data API:8082"
    "developer-tools:Developer Tools API:8083"
    "weather-geo:Weather & Geo API:8084"
    "content-media:Content & Media API:8085"
)

TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

test_subproject() {
    local dir="$1"
    local name="$2"
    local port="$3"

    echo -e "${BLUE}Testing: $name${NC}"
    echo "Directory: $SCRIPT_DIR/$dir"

    # Check if database exists
    if [ ! -f "$SCRIPT_DIR/$dir/apigate.db" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - No database found (not configured yet)"
        ((TOTAL_SKIPPED++))
        echo ""
        return
    fi

    # Check if server is running on this port
    if curl -s "http://localhost:$port/health" > /dev/null 2>&1; then
        health=$(curl -s "http://localhost:$port/health")
        if echo "$health" | grep -q "ok"; then
            echo -e "  ${GREEN}PASS${NC} Health check (port $port)"
            ((TOTAL_PASSED++))
        else
            echo -e "  ${RED}FAIL${NC} Health check returned unexpected response"
            ((TOTAL_FAILED++))
        fi
    else
        echo -e "  ${YELLOW}SKIP${NC} - Server not running on port $port"
        echo "       Start with: PORT=$port $SCRIPT_DIR/$dir/start.sh"
        ((TOTAL_SKIPPED++))
    fi

    echo ""
}

# Test each subproject
for subproject in "${SUBPROJECTS[@]}"; do
    IFS=':' read -r dir name port <<< "$subproject"
    test_subproject "$dir" "$name" "$port"
done

echo "============================================"
echo "Summary"
echo "============================================"
echo -e "Passed:  ${GREEN}$TOTAL_PASSED${NC}"
echo -e "Failed:  ${RED}$TOTAL_FAILED${NC}"
echo -e "Skipped: ${YELLOW}$TOTAL_SKIPPED${NC}"
echo ""

# Database inventory
echo "============================================"
echo "Database Inventory"
echo "============================================"
for subproject in "${SUBPROJECTS[@]}"; do
    IFS=':' read -r dir name port <<< "$subproject"
    db_path="$SCRIPT_DIR/$dir/apigate.db"
    if [ -f "$db_path" ]; then
        size=$(du -h "$db_path" | cut -f1)
        echo -e "  ${GREEN}[OK]${NC} $name ($size)"
    else
        echo -e "  ${YELLOW}[--]${NC} $name (not configured)"
    fi
done
echo ""

echo "============================================"
echo "Quick Start Commands"
echo "============================================"
echo ""
echo "Start individual subprojects:"
for subproject in "${SUBPROJECTS[@]}"; do
    IFS=':' read -r dir name port <<< "$subproject"
    echo "  PORT=$port ./$dir/start.sh"
done
echo ""
echo "Each subproject uses its own SQLite database."
echo "Access admin UI at http://localhost:<port>"
echo ""

[ $TOTAL_FAILED -eq 0 ] && exit 0 || exit 1
