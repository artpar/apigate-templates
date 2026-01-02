# Financial Data API Gateway

Monetize financial market data through a unified gateway. This deployment is configured for fintech companies that want to resell or provide managed access to market data providers.

## Business Use Case

You're building a fintech platform that provides real-time market data. Customers pay you, and you handle the complexity of multiple data provider integrations, rate limiting, and usage tracking.

## Upstreams (Data Providers)

| Provider | Base URL | Auth Type | Use Case |
|----------|----------|-----------|----------|
| Alpha Vantage | alphavantage.co | Query param | Stock quotes, forex, crypto |
| Polygon.io | api.polygon.io | Header (Authorization) | Real-time stock/options data |
| CoinGecko | api.coingecko.com | Header (x-cg-pro-api-key) | Cryptocurrency data |

## Routes

| Route | Upstream | Description |
|-------|----------|-------------|
| `/v1/stocks/*` | alphavantage | Stock quotes and historical data |
| `/v1/market/*` | polygon | Real-time market data, tickers |
| `/v1/crypto/*` | coingecko | Cryptocurrency prices and market cap |
| `/v1/forex/*` | alphavantage | Foreign exchange rates |

## Plans & Pricing

| Plan | Rate Limit | Monthly Calls | Price | Target Customer |
|------|------------|---------------|-------|-----------------|
| Starter | 5 req/min | 500 calls | Free | Hobbyists |
| Developer | 30 req/min | 10K calls | $19/mo | Side projects |
| Professional | 120 req/min | 100K calls | $79/mo | Production apps |
| Enterprise | 600 req/min | 1M calls | $299/mo | Trading platforms |

## Users (Demo)

| Email | Role | Plan | Description |
|-------|------|------|-------------|
| admin@findata.io | Admin | - | Platform administrator |
| trader@hedge.fund | User | Professional | Hedge fund developer |
| dev@fintech.app | User | Developer | Fintech startup |
| hobbyist@gmail.com | User | Starter | Personal project |

## Quick Start

```bash
# Set your API keys
export ALPHAVANTAGE_API_KEY="your-key-here"
export POLYGON_API_KEY="your-key-here"
export COINGECKO_API_KEY="your-key-here"

# Start the gateway
./start.sh

# Access admin UI
open http://localhost:8080
```

## Test the API

```bash
# Get your API key from the admin UI, then:
curl "http://localhost:8080/v1/stocks/quote?symbol=AAPL" \
  -H "X-API-Key: YOUR_API_KEY"

curl "http://localhost:8080/v1/crypto/simple/price?ids=bitcoin&vs_currencies=usd" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Metering

Call-based metering (each API call counts as 1):
- All routes use request counting for billing
- Premium endpoints (real-time data) can be configured with multipliers
