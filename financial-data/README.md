# Financial Data API Gateway

Monetize market data through a unified gateway with **data-point-based billing**.

## Unique Features Demonstrated

| Feature | Implementation |
|---------|---------------|
| **Protocol** | HTTP buffered |
| **Metering** | Custom expressions with conditional logic |
| **Upstream Auth** | Header-based (X-API-Key) |
| **Path Matching** | Prefix matching with path rewriting |
| **Payment** | Paddle integration |

## How Custom Metering Works

Unlike simple request counting, this gateway calculates billing based on data returned:

```javascript
// Count data points in response
len(json(respBody)["Time Series (Daily)"] ?? {})

// Apply premium multiplier for real-time data
* (query.premium == "true" ? 2 : 1)
```

This enables **fair billing based on actual data consumed**, not just API calls.

## Configuration

### Upstreams

| Provider | URL | Auth Type | Auth Value |
|----------|-----|-----------|------------|
| Alpha Vantage | alphavantage.co | Header (X-API-Key) | `${ALPHAVANTAGE_KEY}` |
| Finnhub | finnhub.io | Query param | `token=${FINNHUB_KEY}` |
| Polygon | api.polygon.io | Header (Authorization) | `Bearer ${POLYGON_KEY}` |

### Routes

| Path | Upstream | Path Rewrite | Metering |
|------|----------|--------------|----------|
| `/stocks/*` | alphavantage | trimPrefix | Data points * premium multiplier |
| `/forex/*` | alphavantage | `/query?function=FX_DAILY` | Forex data points |
| `/realtime/*` | finnhub | trimPrefix | `10` (premium flat rate) |
| `/crypto/*` | polygon | `/v2/aggs` + path | `json(respBody).resultsCount ?? 1` |

### Plans

| Plan | Price | Data Points | Rate Limit | Features |
|------|-------|-------------|------------|----------|
| Free | $0 | 500/mo | 5 req/min | 15-min delayed |
| Analyst | $49 | 10,000/mo | 30 req/min | Real-time quotes |
| Trader | $149 | 100,000/mo | 120 req/min | Real-time + historical |
| Institution | $499 | Unlimited | 600 req/min | All features |

## Quick Start

### 1. Set Environment Variables

```bash
export ALPHAVANTAGE_KEY="your-key"
export FINNHUB_KEY="your-key"
export POLYGON_KEY="your-key"
```

### 2. Start the Gateway

```bash
./start.sh
```

### 3. Access Admin Portal

```
http://localhost:8080/portal

Default credentials:
Email: admin@findata.io
Password: FinAdmin123!
```

### 4. Get an API Key

1. Log in to the portal
2. Navigate to API Keys
3. Create a new key
4. Copy the key for testing

## API Usage

### Stock Data

```bash
# Get daily stock data (bills by number of data points returned)
curl "http://localhost:8080/stocks/query?function=TIME_SERIES_DAILY&symbol=AAPL" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Forex Data

```bash
# Get forex rates
curl "http://localhost:8080/forex/EUR/USD" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Real-time Data (Premium)

```bash
# Premium endpoint - 10 data points per call
curl "http://localhost:8080/realtime/quote?symbol=AAPL" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Crypto Aggregates

```bash
# Crypto data - bills by resultsCount
curl "http://localhost:8080/crypto/ticker/X:BTCUSD/range/1/day/2023-01-01/2023-12-31" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Paddle Integration

This deployment uses Paddle for payment processing:

| Plan | Paddle Product ID |
|------|-------------------|
| Free | (no payment) |
| Analyst | `pro_analyst_findata` |
| Trader | `pro_trader_findata` |
| Institution | `pro_institution_findata` |

Configure your Paddle webhook to point to `/webhook/paddle`.

## Technical Details

### Path Rewriting

Requests are rewritten before forwarding to upstreams:

```
# Input: /stocks/query?function=TIME_SERIES_DAILY
# Rewrite: trimPrefix(path, "/stocks")
# Output: /query?function=TIME_SERIES_DAILY
```

### Request Transform

API keys are injected via query parameters:

```
SetQuery: {"apikey": env("ALPHAVANTAGE_KEY")}
```

### Response Transform

Upstream rate limit headers are stripped:

```
DeleteHeaders: ["X-RateLimit-Remaining", "X-RateLimit-Reset"]
```

## Files

| File | Purpose |
|------|---------|
| `apigate.db` | Pre-configured SQLite database |
| `start.sh` | Startup script |
| `test.sh` | Feature verification tests |
| `README.md` | This documentation |
