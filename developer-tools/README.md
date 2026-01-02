# Developer Tools API Gateway

Monetize developer and DevOps APIs through a unified gateway. This deployment is configured for platforms that want to resell or provide managed access to development tools and services.

## Business Use Case

You're building a developer platform that provides access to multiple DevOps services. Customers pay you, and you handle the complexity of multiple API integrations, rate limiting, and usage tracking.

## Upstreams (Service Providers)

| Provider | Base URL | Auth Type | Use Case |
|----------|----------|-----------|----------|
| GitHub | api.github.com | Bearer token | Repositories, issues, actions |
| GitLab | gitlab.com/api | Header (PRIVATE-TOKEN) | CI/CD, repositories |
| npm | registry.npmjs.org | Bearer token | Package registry |

## Routes

| Route | Upstream | Description |
|-------|----------|-------------|
| `/v1/github/*` | github | GitHub API access |
| `/v1/gitlab/*` | gitlab | GitLab API access |
| `/v1/npm/*` | npm | npm registry access |

## Plans & Pricing

| Plan | Rate Limit | Monthly Calls | Price | Target Customer |
|------|------------|---------------|-------|-----------------|
| Free | 10 req/min | 1K calls | $0 | Testing |
| Starter | 60 req/min | 10K calls | $29/mo | Individual devs |
| Team | 300 req/min | 100K calls | $99/mo | Small teams |
| Enterprise | 1000 req/min | 1M calls | $399/mo | Large organizations |

## Users (Demo)

| Email | Role | Plan | Description |
|-------|------|------|-------------|
| admin@devtools.io | Admin | - | Platform administrator |
| dev@startup.com | User | Starter | Solo developer |
| lead@agency.com | User | Team | Agency team lead |
| ops@enterprise.com | User | Enterprise | Enterprise DevOps |

## Quick Start

```bash
# Set your API keys
export GITHUB_TOKEN="ghp_..."
export GITLAB_TOKEN="glpat-..."
export NPM_TOKEN="npm_..."

# Start the gateway
./start.sh

# Access admin UI
open http://localhost:8080
```

## Test the API

```bash
# Get your API key from the admin UI, then:
curl "http://localhost:8080/v1/github/user" \
  -H "X-API-Key: YOUR_API_KEY"

curl "http://localhost:8080/v1/npm/-/package/react/dist-tags" \
  -H "X-API-Key: YOUR_API_KEY"
```

## Metering

Call-based metering (each API call counts as 1):
- All routes use request counting for billing
- Heavy endpoints can be configured with multipliers
