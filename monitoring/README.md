# APIGate Monitoring

Pre-built Grafana dashboards and Prometheus configuration for monitoring APIGate deployments.

## Quick Start

### 1. Start Prometheus + Grafana

```bash
docker-compose up -d
```

### 2. Import the Dashboard

1. Open Grafana at http://localhost:3000 (admin/admin)
2. Go to Dashboards > Import
3. Upload `grafana-dashboard.json`
4. Select your Prometheus datasource
5. Click Import

### 3. Configure APIGate

Ensure your APIGate instance exposes metrics at `/metrics`:

```bash
curl http://localhost:8080/metrics
```

## Dashboard Panels

### Overview Row
| Panel | Description |
|-------|-------------|
| Request Rate | Requests per second (5m average) |
| P95 Latency | 95th percentile response time |
| Error Rate | Percentage of 5xx responses |
| Active Users | Count of users with activity |

### Request Metrics Row
| Panel | Description |
|-------|-------------|
| Requests by Route | Traffic breakdown by API route |
| Requests by Status | HTTP status code distribution |

### Latency Row
| Panel | Description |
|-------|-------------|
| Latency Percentiles | p50, p90, p99 response times |
| P95 by Route | Per-route latency comparison |

### Usage & Quotas Row
| Panel | Description |
|-------|-------------|
| Usage by Plan | Metered usage per pricing plan |
| Quota Usage % | How close users are to limits |

### Rate Limiting Row
| Panel | Description |
|-------|-------------|
| Rate Limited by Route | Which routes are hitting limits |
| Rate Limited by Plan | Which plans are hitting limits |

## Prometheus Metrics

APIGate exposes these metrics at `/metrics`:

```
# Request metrics
apigate_http_requests_total{route, status, method}
apigate_http_request_duration_seconds_bucket{route, le}

# Usage metrics
apigate_usage_total{user, plan, route}
apigate_quota_used{user}
apigate_quota_limit{user}

# Rate limiting
apigate_rate_limited_total{user, plan, route}

# User info
apigate_user_info{user, plan, email}
```

## Alerting Rules (Optional)

Add to your Prometheus alerting rules:

```yaml
groups:
  - name: apigate
    rules:
      - alert: HighErrorRate
        expr: sum(rate(apigate_http_requests_total{status=~"5.."}[5m])) / sum(rate(apigate_http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate (>5%)"

      - alert: HighLatency
        expr: histogram_quantile(0.95, sum(rate(apigate_http_request_duration_seconds_bucket[5m])) by (le)) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P95 latency > 1 second"

      - alert: QuotaExhausted
        expr: apigate_quota_used / apigate_quota_limit > 0.9
        for: 1m
        labels:
          severity: info
        annotations:
          summary: "User approaching quota limit (>90%)"
```

## Files

| File | Description |
|------|-------------|
| `grafana-dashboard.json` | Main APIGate dashboard |
| `docker-compose.yml` | Prometheus + Grafana stack |
| `prometheus.yml` | Prometheus scrape config |
| `README.md` | This documentation |
