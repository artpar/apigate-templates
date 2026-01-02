# Developer Tools API Gateway

Monetize DevOps APIs through a unified gateway with **overage pricing**.

## Unique Features Demonstrated

| Feature | Implementation |
|---------|---------------|
| **Protocol** | HTTP buffered |
| **Metering** | Per-request with overage billing |
| **Upstream Auth** | Mixed (Bearer, Header, Basic) |
| **Path Matching** | Regex with named captures |
| **Payment** | LemonSqueezy integration |

## How Overage Pricing Works

Unlike hard quotas, this gateway allows usage beyond limits with per-request billing:

```
Plan: Team - 10,000 requests/month @ $29
Overage: $0.005 per additional request

Example: 15,000 requests = $29 + (5,000 x $0.005) = $54
```

This enables **flexible scaling without service interruption**.

## Configuration

### Upstreams

| Provider | URL | Auth Type | Auth Value |
|----------|-----|-----------|------------|
| GitHub | api.github.com | Bearer | `${GITHUB_TOKEN}` |
| GitLab | gitlab.com/api/v4 | Header (PRIVATE-TOKEN) | `${GITLAB_TOKEN}` |
| Sentry | sentry.io/api/0 | Bearer | `${SENTRY_TOKEN}` |
| CircleCI | circleci.com/api/v2 | Basic | `${CIRCLECI_TOKEN}:` |

### Routes (Regex Matching)

| Pattern | Upstream | Features |
|---------|----------|----------|
| `/repos/{owner}/{repo}/*` | github | Repository operations |
| `/projects/{id}/pipelines` | gitlab | CI/CD pipelines |
| `/organizations/{org}/issues` | sentry | Error tracking |
| `/project/{slug}/pipeline` | circleci | Build triggers |

### Plans

| Plan | Price | Requests | Rate Limit | Overage |
|------|-------|----------|------------|---------|
| Solo | $0 | 1,000/mo | 60 req/min | Blocked |
| Team | $29 | 10,000/mo | 300 req/min | $0.005/req |
| Business | $99 | 50,000/mo | 600 req/min | $0.003/req |
| Enterprise | $299 | 200,000/mo | 1,200 req/min | $0.001/req |

## Quick Start

### 1. Set Environment Variables

```bash
export GITHUB_TOKEN="ghp_..."
export GITLAB_TOKEN="glpat-..."
export SENTRY_TOKEN="..."
export CIRCLECI_TOKEN="..."
```

### 2. Start the Gateway

```bash
./start.sh
```

### 3. Access Admin Portal

```
http://localhost:8080/portal

Default credentials:
Email: admin@devtools.io
Password: DevAdmin123!
```

### 4. Get an API Key

1. Log in to the portal
2. Navigate to API Keys
3. Create a new key
4. Copy the key for testing

## API Usage

### GitHub Repository

```bash
# Get repository info (regex captures {owner} and {repo})
curl "http://localhost:8080/repos/octocat/hello-world/info" \
  -H "X-API-Key: YOUR_API_KEY"
```

### GitLab Pipeline

```bash
# Trigger pipeline (regex captures {id})
curl "http://localhost:8080/projects/12345/pipelines" \
  -H "X-API-Key: YOUR_API_KEY"
```

### Sentry Issues

```bash
# Get organization issues (regex captures {org})
curl "http://localhost:8080/organizations/my-org/issues" \
  -H "X-API-Key: YOUR_API_KEY"
```

### CircleCI Build

```bash
# Trigger build (regex captures {slug})
curl -X POST "http://localhost:8080/project/gh/org/repo/pipeline" \
  -H "X-API-Key: YOUR_API_KEY"
```

## LemonSqueezy Integration

This deployment uses LemonSqueezy for payment processing:

| Plan | LemonSqueezy Variant ID |
|------|-------------------------|
| Solo | (no payment) |
| Team | `variant_team_devtools` |
| Business | `variant_business_devtools` |
| Enterprise | `variant_enterprise_devtools` |

Configure your LemonSqueezy webhook to point to `/webhook/lemonsqueezy`.

## Technical Details

### Regex Path Matching

Named captures extract path parameters:

```
Pattern: /repos/{owner}/{repo}/*
Input:   /repos/octocat/hello-world/commits
Captures: owner=octocat, repo=hello-world
```

### Multiple Auth Types

Different upstreams use different authentication:

```
GitHub:   Authorization: Bearer ${GITHUB_TOKEN}
GitLab:   PRIVATE-TOKEN: ${GITLAB_TOKEN}
CircleCI: Basic Auth (token as username)
```

### Request Transform

User context is forwarded:

```
SetHeaders: {"X-Forwarded-User": userID, "Accept": "application/json"}
```

### Response Transform

Responses are normalized:

```
BodyExpr: {"data": respBody, "meta": {"source": "devtools", "timestamp": now()}}
```

## Files

| File | Purpose |
|------|---------|
| `apigate.db` | Pre-configured SQLite database |
| `start.sh` | Startup script |
| `test.sh` | Feature verification tests |
| `README.md` | This documentation |
