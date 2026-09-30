# OneNews API Reference

## Base URL
```
https://your-project.supabase.co
```

## Authentication

### Phone + OTP
```http
POST /auth/v1/otp
Content-Type: application/json

{
  "phone": "+250781234567"
}
```

```http
POST /auth/v1/token?grant_type=otp
Content-Type: application/json

{
  "phone": "+250781234567",
  "token": "123456"
}
```

## Articles

### List Articles
```http
GET /rest/v1/articles?select=*,sources(name),categories(name)&status=eq.published&order=published_at.desc&limit=20
```

### Get Article
```http
GET /rest/v1/articles?id=eq.{articleId}&select=*,sources(name),categories(name)
```

### Search Articles
```http
POST /rest/v1/rpc/search_articles
Content-Type: application/json

{
  "search_query": "MTN",
  "max_results": 20
}
```

## Categories

### List Categories
```http
GET /rest/v1/categories?select=*&is_active=eq.true&order=sort_order.asc
```

## Digests

### Get Latest Digest
```http
GET /rest/v1/digests?select=*&date=eq.{date}&period=eq.{period}&order=created_at.desc&limit=1
```

### Get Digest Articles
```http
GET /rest/v1/articles?id=in.({storyIds})&select=*,sources(name),categories(name)
```

## User Profile

### Get Profile
```http
GET /rest/v1/profiles?select=*&id=eq.{userId}
Authorization: Bearer {access_token}
```

### Update Profile
```http
PATCH /rest/v1/profiles?id=eq.{userId}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "language": "rw",
  "display_density": "compact"
}
```

## Saved Stories

### Save Story
```http
POST /rest/v1/saved_stories
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "article_id": "{articleId}"
}
```

### Remove Saved Story
```http
DELETE /rest/v1/saved_stories?article_id=eq.{articleId}
Authorization: Bearer {access_token}
```

### List Saved Stories
```http
GET /rest/v1/saved_stories?select=articles(*,sources(name),categories(name))&user_id=eq.{userId}
Authorization: Bearer {access_token}
```

## Subscriptions

### Create Subscription
```http
POST /rest/v1/subscriptions
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "tier": "premium",
  "provider": "flutterwave"
}
```

### Get Subscriptions
```http
GET /rest/v1/subscriptions?user_id=eq.{userId}
Authorization: Bearer {access_token}
```

## Analytics

### Track Event
```http
POST /rest/v1/analytics_events
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "event_name": "story_read",
  "event_data": {
    "article_id": "{articleId}",
    "dwell_time_seconds": 45
  }
}
```

## Edge Functions

### Summarize Article
```http
POST /functions/v1/summarize
Content-Type: application/json

{
  "articleId": "{articleId}",
  "title": "Article Title",
  "content": "Article content...",
  "language": "en"
}
```

### Ingest RSS
```http
POST /functions/v1/ingest-rss
```

### Generate Digest
```http
POST /functions/v1/generate-digest
Content-Type: application/json

{
  "date": "2026-09-29",
  "period": "morning"
}
```

### Send Push Notification
```http
POST /functions/v1/send-push
Content-Type: application/json

{
  "articleId": "{articleId}",
  "title": "Breaking News",
  "body": "Summary of breaking news..."
}
```

### Process Payment
```http
POST /functions/v1/process-payment
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "userId": "{userId}",
  "phone": "+250781234567",
  "amount": 300,
  "currency": "RWF",
  "provider": "flutterwave",
  "tier": "premium"
}
```

## Error Codes

| Code | Meaning |
|---|---|
| 400 | Bad Request — missing or invalid parameters |
| 401 | Unauthorized — invalid or expired token |
| 403 | Forbidden — insufficient permissions |
| 404 | Not Found — resource does not exist |
| 429 | Too Many Requests — rate limit exceeded |
| 500 | Internal Server Error |

## Rate Limits

| Endpoint | Limit |
|---|---|
| Articles | 100 requests/minute |
| Search | 20 requests/minute |
| Auth | 10 requests/minute |
| Edge Functions | 100 requests/minute |
