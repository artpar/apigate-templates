# Content & Media API Gateway

Monetize content and media APIs through a unified gateway. This deployment is configured for platforms that aggregate images, videos, and news content.

## Business Use Case

You're building a content aggregation platform that needs stock photos, video hosting, and news feeds. Customers pay you for a unified API that handles multiple provider integrations.

## Upstreams (Service Providers)

| Provider | Base URL | Auth Type | Use Case |
|----------|----------|-----------|----------|
| Unsplash | api.unsplash.com | Header (Authorization) | Stock photos |
| Pexels | api.pexels.com | Header (Authorization) | Stock photos/videos |
| NewsAPI | newsapi.org | Query param (apiKey) | News articles |

## Routes

| Route | Upstream | Description |
|-------|----------|-------------|
| `/v1/photos/*` | unsplash | Stock photo search |
| `/v1/media/*` | pexels | Photos and videos |
| `/v1/news/*` | newsapi | News articles |

## Plans & Pricing

| Plan | Rate Limit | Monthly Calls | Price | Target Customer |
|------|------------|---------------|-------|-----------------|
| Free | 10 req/min | 500 calls | $0 | Testing |
| Creator | 30 req/min | 10K calls | $29/mo | Content creators |
| Agency | 120 req/min | 100K calls | $79/mo | Marketing agencies |
| Enterprise | 600 req/min | 1M calls | $299/mo | Media companies |

## Users (Demo)

| Email | Role | Plan | Description |
|-------|------|------|-------------|
| admin@contentapi.io | Admin | - | Platform administrator |
| blogger@gmail.com | User | Creator | Independent blogger |
| team@agency.co | User | Agency | Marketing agency |
| media@publisher.com | User | Enterprise | News publisher |

## Quick Start

```bash
# Set your API keys
export UNSPLASH_ACCESS_KEY="your-access-key"
export PEXELS_API_KEY="your-api-key"
export NEWSAPI_KEY="your-api-key"

# Start the gateway
./start.sh

# Access admin UI
open http://localhost:8080
```

## Test the API

```bash
# Get your API key from the admin UI, then:
curl "http://localhost:8080/v1/photos/search?query=nature" \
  -H "X-API-Key: YOUR_API_KEY"

curl "http://localhost:8080/v1/news/top-headlines?country=us" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Metering

Call-based metering (each API call counts as 1):
- Photo searches count as 1 call
- Media lookups count as 1 call
- News queries count as 1 call
