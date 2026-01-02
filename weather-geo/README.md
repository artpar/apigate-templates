# Weather & Geo API Gateway

Monetize location services through a unified gateway with **geography-based pricing**.

## Unique Features Demonstrated

| Feature | Implementation |
|---------|---------------|
| **Protocol** | HTTP buffered |
| **Metering** | Batch counting (response field extraction) |
| **Upstream Auth** | Query parameter injection |
| **Path Matching** | Mixed (exact + prefix) |
| **Payment** | Stripe integration |

## How Query Param Auth Works

Unlike header-based authentication, this gateway injects API keys as query parameters:

```javascript
// Request transform injects auth before forwarding
SetQuery: {"appid": env("OPENWEATHER_KEY"), "units": "metric"}

// Input:  /weather/current?q=London
// Output: /data/2.5/weather?q=London&appid=xxx&units=metric
```

This enables **seamless integration with Google-style APIs**.

## Configuration

### Upstreams

| Provider | URL | Auth Type | Notes |
|----------|-----|-----------|-------|
| OpenWeatherMap | api.openweathermap.org | Query (appid) | Weather data |
| MapBox | api.mapbox.com | Query (access_token) | Geocoding |
| IPInfo | ipinfo.io | Query (token) | IP geolocation |

### Routes

| Path | Match | Rate Limit | Metering |
|------|-------|------------|----------|
| `/weather/current` | Exact | 60/min | `1` |
| `/weather/forecast` | Exact | 30/min | Forecast count |
| `/geocode/*` | Prefix | 10/min | Feature count |
| `/ip/*` | Prefix | 120/min | `1` |
| `/maps/*` | Prefix | 5/min | `5` (heavy) |

### Plans

| Plan | Price | Quota | Rate Limit | Coverage |
|------|-------|-------|------------|----------|
| Local | $0 | 1,000/mo | 60 req/min | 1 city |
| Regional | $19 | 10,000/mo | 120 req/min | 1 country |
| National | $49 | 50,000/mo | 300 req/min | 10 countries |
| Global | $149 | Unlimited | 600 req/min | Worldwide |

## Quick Start

### 1. Set Environment Variables

```bash
export OPENWEATHER_KEY="your-api-key"
export MAPBOX_TOKEN="your-access-token"
export IPINFO_TOKEN="your-token"
```

### 2. Start the Gateway

```bash
./start.sh
```

### 3. Access Admin Portal

```
http://localhost:8080/portal

Default credentials:
Email: admin@weathergeo.io
Password: GeoAdmin123!
```

### 4. Get an API Key

1. Log in to the portal
2. Navigate to API Keys
3. Create a new key
4. Copy the key for testing

## API Usage

### Current Weather

```bash
# Get current weather (exact path match)
curl "http://localhost:8080/weather/current?q=London" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Weather Forecast

```bash
# Get 5-day forecast (bills by forecast count)
curl "http://localhost:8080/weather/forecast?q=London" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Geocoding

```bash
# Forward geocoding (prefix match, bills by feature count)
curl "http://localhost:8080/geocode/forward?q=New+York" \
  -H "X-API-Key: YOUR_API_KEY"
```

### IP Geolocation

```bash
# IP lookup (fast endpoint, 120 req/min)
curl "http://localhost:8080/ip/8.8.8.8" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Maps (Heavy Endpoint)

```bash
# Map tiles (rate limited to 5/min, bills 5 units per call)
curl "http://localhost:8080/maps/static/v1/mapbox.streets/0/0/0.png" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Stripe Integration

This deployment uses Stripe for payment processing:

| Plan | Stripe Price ID |
|------|-----------------|
| Local | (no payment) |
| Regional | `price_regional_weathergeo` |
| National | `price_national_weathergeo` |
| Global | `price_global_weathergeo` |

Configure your Stripe webhook to point to `/webhook/stripe`.

## Technical Details

### Per-Endpoint Rate Limiting

Different endpoints have different rate limits:

| Endpoint | Rate Limit | Reason |
|----------|------------|--------|
| `/weather/current` | 60/min | Light query |
| `/weather/forecast` | 30/min | Heavier computation |
| `/geocode/*` | 10/min | API quota protection |
| `/ip/*` | 120/min | Very fast lookups |
| `/maps/*` | 5/min | Bandwidth intensive |

### Batch Metering

Forecast and geocode endpoints bill by results returned:

```javascript
// Forecast: bill by number of forecast periods
json(respBody).list ? len(json(respBody).list) : 1

// Geocoding: bill by number of features
json(respBody).features ? len(json(respBody).features) : 1
```

### Request Transform

API keys and defaults are injected:

```
SetQuery: {"appid": env("OPENWEATHER_KEY"), "units": "metric"}
```

### Response Transform

Cache headers are added:

```
SetHeaders: {"X-Cache-TTL": "300", "X-Data-Source": "aggregated"}
```

## Files

| File | Purpose |
|------|---------|
| `apigate.db` | Pre-configured SQLite database |
| `start.sh` | Startup script |
| `test.sh` | Feature verification tests |
| `README.md` | This documentation |
