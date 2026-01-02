# LLM API Gateway

Monetize AI and LLM APIs through a unified gateway. This deployment is configured for businesses that want to resell or provide managed access to AI models.

## Business Use Case

You're building an AI platform that provides access to multiple LLM providers. Customers pay you, and you handle the complexity of multiple API integrations, rate limiting, and usage tracking.

## Upstreams (AI Providers)

| Provider | Base URL | Auth Type | Use Case |
|----------|----------|-----------|----------|
| Anthropic | api.anthropic.com | Header (x-api-key) | Claude models for reasoning |
| OpenAI | api.openai.com | Bearer token | GPT models, embeddings |
| Gemini | generativelanguage.googleapis.com | Query param | Google's Gemini models |

## Routes

| Route | Upstream | Protocol | Description |
|-------|----------|----------|-------------|
| `/v1/anthropic/*` | anthropic | SSE | Claude chat/messages API |
| `/v1/openai/*` | openai | SSE | OpenAI chat completions |
| `/v1/gemini/*` | gemini | HTTP Stream | Gemini generateContent |
| `/v1/models` | - | HTTP | List available models |

## Plans & Pricing

| Plan | Rate Limit | Monthly Tokens | Price | Target Customer |
|------|------------|----------------|-------|-----------------|
| Explorer | 20 req/min | 100K tokens | Free | Developers testing |
| Startup | 60 req/min | 1M tokens | $29/mo | Small projects |
| Growth | 200 req/min | 10M tokens | $99/mo | Production apps |
| Enterprise | 1000 req/min | Unlimited | Custom | Large scale |

## Users (Demo)

| Email | Role | Plan | Description |
|-------|------|------|-------------|
| admin@llm-gateway.io | Admin | - | Platform administrator |
| demo@startup.ai | User | Startup | AI startup building chatbot |
| dev@enterprise.com | User | Growth | Enterprise development team |
| test@free.com | User | Explorer | Free tier tester |

## Quick Start

```bash
# Set your API keys
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="AIza..."

# Start the gateway
./start.sh

# Access admin UI
open http://localhost:8080
```

## Test the API

```bash
# Get your API key from the admin UI, then:
curl -X POST http://localhost:8080/v1/anthropic/messages \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Metering

Token-based metering using SSE stream parsing:
- Anthropic: `json(sseLastData(allData)).usage.total_tokens`
- OpenAI: `json(sseLastData(allData)).usage.total_tokens`
- Gemini: `json(respBody).usageMetadata.totalTokenCount`
