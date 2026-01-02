# Content & Media API Gateway

Monetize media APIs through a unified gateway with **bandwidth-based billing**.

## Unique Features Demonstrated

| Feature | Implementation |
|---------|---------------|
| **Protocol** | HTTP streaming (chunked transfer) |
| **Metering** | Response bytes (KB-based billing) |
| **Upstream Auth** | Header-based |
| **Path Matching** | Prefix matching |
| **Payment** | Free-tier focused |

## How Bandwidth Billing Works

Unlike request-based billing, this gateway meters actual bytes transferred:

```javascript
// Metering expression: KB transferred
responseBytes / 1024

// Example: 5MB image = 5,120 KB billed
```

This enables **fair billing for media-heavy APIs** where file sizes vary significantly.

## Configuration

### Upstreams

| Provider | URL | Auth Type | Auth Value |
|----------|-----|-----------|------------|
| Unsplash | api.unsplash.com | Header (Authorization) | `Client-ID ${UNSPLASH_KEY}` |
| Pexels | api.pexels.com | Header (Authorization) | `${PEXELS_KEY}` |
| NewsAPI | newsapi.org | Query (apiKey) | `${NEWSAPI_KEY}` |

### Routes

| Path | Protocol | Metering | Description |
|------|----------|----------|-------------|
| `/photos/*` | HTTP Stream | `responseBytes / 1024` | Stock photos |
| `/videos/*` | HTTP Stream | `responseBytes / 1024` | Video content |
| `/news/*` | HTTP | Article count | News articles |

### Plans

| Plan | Price | Bandwidth | Rate Limit | Quality |
|------|-------|-----------|------------|---------|
| Free | $0 | 100 MB/mo | 60 req/min | Low-res (640px) |
| Creator | $29 | 5 GB/mo | 120 req/min | HD (1920px) |
| Agency | $79 | 50 GB/mo | 300 req/min | 4K (4096px) |
| Enterprise | $299 | Unlimited | 600 req/min | RAW + API |

## Quick Start

### 1. Set Environment Variables

```bash
export UNSPLASH_KEY="your-access-key"
export PEXELS_KEY="your-api-key"
export NEWSAPI_KEY="your-api-key"
```

### 2. Start the Gateway

```bash
./start.sh
```

### 3. Access Admin Portal

```
http://localhost:8080/portal

Default credentials:
Email: admin@contentmedia.io
Password: ContentAdmin123!
```

### 4. Get an API Key

1. Log in to the portal
2. Navigate to API Keys
3. Create a new key
4. Copy the key for testing

## API Usage

### Photo Search

```bash
# Search photos (bills by KB transferred)
curl "http://localhost:8080/photos/search/photos?query=nature" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Get Photo

```bash
# Get specific photo (bills by KB transferred)
curl "http://localhost:8080/photos/photos/abc123" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Video Search

```bash
# Search videos (streaming, bills by KB)
curl "http://localhost:8080/videos/videos/search?query=ocean" \
  -H "X-API-Key: YOUR_API_KEY"
```

### News Headlines

```bash
# Get news (bills by article count)
curl "http://localhost:8080/news/v2/top-headlines?country=us" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Free-Tier Focus

This deployment emphasizes generous free tiers for content creators:

| Feature | Free Plan |
|---------|-----------|
| Bandwidth | 100 MB/month |
| Rate Limit | 60 req/min |
| Quality | 640px max width |
| API Access | Full (with limits) |

Upgrade to paid plans for higher quality and bandwidth.

## Technical Details

### HTTP Streaming Protocol

The gateway uses chunked transfer encoding for efficient media delivery:

```
Transfer-Encoding: chunked
Content-Type: application/octet-stream
```

This allows **real-time streaming without buffering** the entire response.

### Byte-Based Metering

Every response is measured in bytes:

```javascript
// Expression: responseBytes / 1024
// Converts bytes to KB for billing

// 1 MB image = 1024 KB billed
// 100 KB thumbnail = 100 KB billed
```

### Response Transform

Privacy headers are stripped:

```
DeleteHeaders: ["X-Tracking-ID", "X-Analytics-ID"]
```

### Plan-Based Quality (Optional)

Request transforms can adjust quality based on plan:

```javascript
SetQuery: {
  "w": planID == "free" ? "640" : (planID == "creator" ? "1920" : "4096"),
  "q": planID == "free" ? "60" : "100"
}
```

## Bandwidth Quota Examples

| Action | Data Size | Free Plan Impact |
|--------|-----------|------------------|
| Photo search (10 results) | ~50 KB | 0.05% of quota |
| Single HD photo | ~500 KB | 0.5% of quota |
| 4K photo download | ~5 MB | 5% of quota |
| Video preview | ~20 MB | 20% of quota |

## Files

| File | Purpose |
|------|---------|
| `apigate.db` | Pre-configured SQLite database |
| `start.sh` | Startup script |
| `test.sh` | Feature verification tests |
| `README.md` | This documentation |
