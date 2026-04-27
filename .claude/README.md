## .claude/

이 디렉터리는 “하네스”입니다. (LLM이 팀처럼 일하도록 만드는 **역할 정의 + 절차(스킬)** 모음)

### 구성
- `agents/`: 역할(누가 무엇을 책임지는지)
- `skills/`: 반복 절차/오케스트레이션(어떻게 진행하는지)

### 권장 사용 흐름
1) `project-prd.md` 작성
2) `agents/architect.md` 기준으로 `contracts/`와 `ARCHITECTURE.md` 고정
3) `agents/backend-dev.md` / `agents/frontend-dev.md` 병렬 구현
4) `agents/qa-engineer.md`로 `TEST_PLAN.md` / `QA_REPORT.md` 품질 게이트 수행

