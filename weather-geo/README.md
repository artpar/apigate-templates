# Weather & Geo API Gateway

Monetize weather and location APIs through a unified gateway. This deployment is configured for platforms that provide weather forecasts, geocoding, and location-based services.

## Business Use Case

You're building a location-aware application that needs weather data, geocoding, and IP geolocation. Customers pay you for a unified API that handles multiple provider integrations.

## Upstreams (Service Providers)

| Provider | Base URL | Auth Type | Use Case |
|----------|----------|-----------|----------|
| OpenWeatherMap | api.openweathermap.org | Query param (appid) | Weather forecasts |
| MapBox | api.mapbox.com | Query param (access_token) | Geocoding, maps |
| IPInfo | ipinfo.io | Bearer token | IP geolocation |

## Routes

| Route | Upstream | Description |
|-------|----------|-------------|
| `/v1/weather/*` | openweather | Weather data access |
| `/v1/geo/*` | mapbox | Geocoding and maps |
| `/v1/ip/*` | ipinfo | IP geolocation |

## Plans & Pricing

| Plan | Rate Limit | Monthly Calls | Price | Target Customer |
|------|------------|---------------|-------|-----------------|
| Free | 10 req/min | 500 calls | $0 | Testing |
| Hobby | 30 req/min | 5K calls | $19/mo | Side projects |
| Pro | 120 req/min | 50K calls | $49/mo | Apps in production |
| Business | 600 req/min | 500K calls | $199/mo | High-traffic apps |

## Users (Demo)

| Email | Role | Plan | Description |
|-------|------|------|-------------|
| admin@weathergeo.io | Admin | - | Platform administrator |
| hobbyist@gmail.com | User | Hobby | Weekend developer |
| dev@mobileapp.co | User | Pro | Mobile app developer |
| api@logistics.com | User | Business | Logistics company |

## Quick Start

```bash
# Set your API keys
export OPENWEATHERMAP_API_KEY="your-key"
export MAPBOX_ACCESS_TOKEN="your-token"
export IPINFO_TOKEN="your-token"

# Start the gateway
./start.sh

# Access admin UI
open http://localhost:8080
```

## Test the API

```bash
# Get your API key from the admin UI, then:
curl "http://localhost:8080/v1/weather/data/2.5/weather?q=London" \
  -H "X-API-Key: YOUR_API_KEY"

curl "http://localhost:8080/v1/ip/8.8.8.8" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Metering

Call-based metering (each API call counts as 1):
- Weather queries count as 1 call
- Geocoding lookups count as 1 call
- IP lookups count as 1 call
