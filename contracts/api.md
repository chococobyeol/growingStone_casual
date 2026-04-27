## API Contracts (초안)

### 규칙
- 모든 응답은 JSON
- 에러는 `{ "error": { "code": string, "message": string, "details"?: any } }`

### 엔드포인트(예시)

#### GET /health
- **200**

```json
{ "ok": true }
```

