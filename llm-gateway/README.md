# LLM API Gateway

Monetize AI and LLM APIs through a unified gateway with **token-based billing**.

## Unique Features Demonstrated

| Feature | Implementation |
|---------|---------------|
| **Protocol** | SSE (Server-Sent Events) for streaming responses |
| **Metering** | Token extraction from SSE data |
| **Upstream Auth** | Bearer tokens |
| **Path Matching** | Exact path matching |
| **Payment** | Stripe integration |

## How Token Metering Works

Unlike request-based billing, this gateway extracts token counts from streaming LLM responses:

```
# OpenAI/Anthropic responses include usage data in the final SSE event:
data: {"usage": {"total_tokens": 523, "input_tokens": 100, "output_tokens": 423}}

# The metering expression extracts this:
json(sseLastData(allData)).usage.total_tokens ?? 1
```

This enables **accurate billing based on actual token consumption**, not just API calls.

## Configuration

### Upstreams

| Provider | URL | Auth Type | Auth Value |
|----------|-----|-----------|------------|
| OpenAI | api.openai.com | Bearer | `${OPENAI_API_KEY}` |
| Anthropic | api.anthropic.com | Header (x-api-key) | `${ANTHROPIC_API_KEY}` |
| Google | generativelanguage.googleapis.com | Query param | `key=${GOOGLE_API_KEY}` |

### Routes

| Path | Protocol | Metering Expression |
|------|----------|---------------------|
| `/v1/chat/completions` | SSE | `json(sseLastData(allData)).usage.total_tokens ?? 1` |
| `/v1/messages` | SSE | Input + output tokens from Anthropic |

### Plans

| Plan | Price | Token Quota | Rate Limit | Overage |
|------|-------|-------------|------------|---------|
| Free | $0 | 10,000/mo | 1,000 tokens/min | Blocked |
| Starter | $29 | 100,000/mo | 10,000 tokens/min | $0.002/token |
| Pro | $99 | 1,000,000/mo | 100,000 tokens/min | $0.001/token |
| Enterprise | $499 | Unlimited | Unlimited | N/A |

## Quick Start

### 1. Set Environment Variables

```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="AIza..."
```

### 2. Start the Gateway

```bash
./start.sh
```

### 3. Access Admin Portal

```
http://localhost:8080/portal

Default credentials:
Email: admin@llm-gateway.io
Password: LLMAdmin123!
```

### 4. Get an API Key

1. Log in to the portal
2. Navigate to API Keys
3. Create a new key
4. Copy the key for testing

## API Usage

### OpenAI Chat Completions

```bash
curl -X POST http://localhost:8080/v1/chat/completions \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello!"}],
    "stream": true
  }'
```

### Anthropic Messages

```bash
curl -X POST http://localhost:8080/v1/messages \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Stripe Integration

This deployment uses Stripe for payment processing:

| Plan | Stripe Price ID |
|------|-----------------|
| Free | (no payment) |
| Starter | `price_starter_llmgateway` |
| Pro | `price_pro_llmgateway` |
| Enterprise | `price_enterprise_llmgateway` |

Configure your Stripe webhook to point to `/webhook/stripe`.

## Technical Details

### SSE Token Extraction

The gateway buffers the entire SSE stream and extracts token counts from the final `data:` event:

```javascript
// Expression: json(sseLastData(allData)).usage.total_tokens ?? 1

// sseLastData() - Gets the last SSE data event
// json() - Parses the JSON
// .usage.total_tokens - Extracts the token count
// ?? 1 - Fallback to 1 if not found
```

### Request Transform

All requests include user context headers:

```
X-User-ID: {authenticated user ID}
X-Plan-ID: {user's plan identifier}
```

## Files

| File | Purpose |
|------|---------|
| `apigate.db` | Pre-configured SQLite database |
| `start.sh` | Startup script |
| `test.sh` | Feature verification tests |
| `README.md` | This documentation |
