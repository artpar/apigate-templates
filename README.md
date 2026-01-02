# APIGate Subproject Deployments

Ready-to-use APIGate configurations for different business use cases. Each subproject includes a pre-configured SQLite database that serves as a complete deployment template.

## Subprojects

| Subproject | Use Case | Monthly Revenue | Port |
|------------|----------|-----------------|------|
| [llm-gateway](llm-gateway/) | AI/LLM API monetization | $797 | 8081 |
| [financial-data](financial-data/) | Market data APIs | $347 | 8082 |
| [developer-tools](developer-tools/) | DevOps & CI/CD APIs | $247 | 8083 |
| [weather-geo](weather-geo/) | Location & weather APIs | $267 | 8084 |
| [content-media](content-media/) | Media & content APIs | $407 | 8085 |

**Total Potential Monthly Revenue: $2,065**

## Quick Start

```bash
# Start a specific subproject
cd llm-gateway
./start.sh

# Or specify a port
PORT=8081 ./llm-gateway/start.sh
```

## How It Works

Each subproject contains:
- `apigate.db` - Pre-configured SQLite database (the deliverable)
- `start.sh` - Startup script that points to the database
- `test.sh` - Basic endpoint tests
- `README.md` - Business context and configuration details

The SQLite database IS the deployment. Once configured via the admin UI, copy the database file to use it as a starting point for new deployments.

## Architecture

```
subprojects/
├── test-all.sh              # Master test script
├── README.md                # This file
├── llm-gateway/
│   ├── apigate.db           # LLM Gateway configuration
│   ├── start.sh
│   ├── test.sh
│   └── README.md
├── financial-data/
│   └── ...
├── developer-tools/
│   └── ...
├── weather-geo/
│   └── ...
└── content-media/
    └── ...
```

## Testing

```bash
# Test all subprojects
./test-all.sh

# Test individual subproject
cd llm-gateway && ./test.sh
```

## Environment Variables

Each subproject uses:
- `APIGATE_DATABASE_DSN` - Path to SQLite database (set automatically by start.sh)
- `PORT` - Server port (default: 8080)
- Provider-specific API keys (e.g., `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)

## Use Cases

### LLM Gateway ($797/mo)
Monetize AI APIs (OpenAI, Anthropic, Google). Token-based metering for accurate billing.

### Financial Data ($347/mo)
Aggregate market data from Alpha Vantage, Finnhub, Polygon.io for fintech apps.

### Developer Tools ($247/mo)
Unified DevOps API: GitHub, GitLab, CircleCI, Sentry integration.

### Weather & Geo ($267/mo)
Location services: OpenWeather, Mapbox, IPInfo for mobile and logistics apps.

### Content & Media ($407/mo)
Content aggregation: Unsplash, Pexels, NewsAPI for media platforms.
