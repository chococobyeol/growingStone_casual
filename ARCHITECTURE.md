## Architecture (초안)

이 문서는 `project-prd.md`를 기반으로 **계약/경계/결정사항**을 기록하는 용도입니다.

### 결정사항(Decision Log)
- (예) 프론트/백 분리 여부
- (예) 인증 방식
- (예) 저장소(Postgres vs SQLite 등)

### 모듈/폴더 구조(예시)

```
contracts/          # 경계 계약(API/Data)
backend/            # 서버
frontend/           # 클라이언트
e2e/                # E2E 테스트(선택)
```

