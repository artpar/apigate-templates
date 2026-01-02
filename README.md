# APIGate Subproject Deployments

Ready-to-use APIGate configurations showcasing different feature combinations. Each subproject demonstrates unique capabilities for different business use cases.

## Feature Coverage Matrix

| Feature | LLM Gateway | Financial Data | Developer Tools | Weather & Geo | Content & Media |
|---------|-------------|----------------|-----------------|---------------|-----------------|
| **Protocol** | SSE | HTTP buffered | HTTP buffered | HTTP buffered | HTTP stream |
| **Metering** | Token extraction | Custom expressions | Per-request + overage | Batch counting | Response bytes |
| **Upstream Auth** | Bearer | Header | Header/Basic (mixed) | Query param | Header |
| **Path Match** | Exact | Prefix + rewrite | Regex captures | Mixed | Prefix |
| **Payment** | Stripe | Paddle | LemonSqueezy | Stripe | Free-tier focus |

## Subprojects

| Subproject | Use Case | Unique Showcase | Port |
|------------|----------|-----------------|------|
| [llm-gateway](llm-gateway/) | AI/LLM API monetization | SSE streaming, token-based billing | 8081 |
| [financial-data](financial-data/) | Market data APIs | Custom metering expressions, Paddle | 8082 |
| [developer-tools](developer-tools/) | DevOps & CI/CD APIs | Regex routing, overage pricing | 8083 |
| [weather-geo](weather-geo/) | Location & weather APIs | Query param auth, per-endpoint limits | 8084 |
| [content-media](content-media/) | Media & content APIs | HTTP streaming, bandwidth billing | 8085 |

## Quick Start

```bash
# 1. Navigate to a subproject
cd llm-gateway

# 2. Set required environment variables (see subproject README)
export OPENAI_API_KEY="sk-..."

# 3. Start the gateway
./start.sh

# 4. Access the admin UI
open http://localhost:8080/portal
```

## How It Works

Each subproject contains:
- `apigate.db` - Pre-configured SQLite database (the deployable artifact)
- `start.sh` - Startup script
- `test.sh` - Feature-specific tests
- `README.md` - Business context and feature documentation

The SQLite database IS the deployment. Copy it to use as a starting point for new deployments.

## Environment Variables

All subprojects use:
- `APIGATE_DATABASE_DSN` - Path to SQLite database (set by start.sh)
- `PORT` - Server port (default: 8080)
- Provider-specific API keys (documented in each README)

## Testing

```bash
# Test all subprojects
./test-all.sh

# Test individual subproject
cd llm-gateway && ./test.sh
```

## Architecture

```
subprojects/
├── README.md                # This file (feature overview)
├── test-all.sh              # Master test script
├── llm-gateway/
│   ├── apigate.db           # SSE + token metering config
│   ├── start.sh
│   ├── test.sh
│   └── README.md
├── financial-data/
│   ├── apigate.db           # Custom expressions + Paddle
│   └── ...
├── developer-tools/
│   ├── apigate.db           # Regex + overage pricing
│   └── ...
├── weather-geo/
│   ├── apigate.db           # Query auth + per-endpoint
│   └── ...
└── content-media/
    ├── apigate.db           # HTTP streaming + bandwidth
    └── ...
```

## Feature Demonstrations

### SSE Protocol (LLM Gateway)
- Real-time streaming responses for LLM APIs
- Token extraction from SSE data using `sseLastData()`
- Token-based quota management

### Custom Metering Expressions (Financial Data)
- Data-point billing: `len(json(respBody)["Time Series"] ?? {})`
- Conditional multipliers: `* (query.premium == "true" ? 2 : 1)`
- Response field extraction

### Regex Path Matching (Developer Tools)
- Named captures: `/repos/{owner}/{repo}/*`
- Pattern-based routing to different upstreams
- Overage pricing model

### Query Parameter Auth (Weather & Geo)
- Google-style auth: `?appid=${API_KEY}`
- Request transform injection
- Per-endpoint rate limiting

### Bandwidth Billing (Content & Media)
- HTTP chunked streaming
- Byte-based metering: `responseBytes / 1024`
- Bandwidth quotas (MB/GB per month)
