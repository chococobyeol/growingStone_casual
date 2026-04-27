# Project Orchestrator (Harness Skill)

## 목적
`project-prd.md`를 입력으로 받아, 에이전트 팀이 **역할 분리 + 계약 고정 + 병렬 구현 + 품질 게이트** 순서로 진행하도록 오케스트레이션한다.

## 실행 순서(권장)

### 0) 입력 확인
- `project-prd.md`를 읽고
  - 가정(Assumptions)
  - 범위(Scope)
  - 성공 기준(Success Criteria)
  를 10줄 이내로 요약한다.

### 1) Architect 단계 (계약/구조 고정)
- `ARCHITECTURE.md`, `contracts/api.md`, `contracts/data.md`를 생성한다.
- 백엔드/프론트가 “독립적으로 진행 가능”할 수준으로 계약을 구체화한다.
 - 결정사항은 `ARCHITECTURE.md`의 Decision Log에 누적한다.

### 2) Backend/Frontend 병렬 단계
- backend-dev는 계약 기반으로 서버를 구현하고, 실행 방법을 남긴다.
- frontend-dev는 계약 기반으로 UI를 구현하고, 핵심 플로우를 데모로 만든다.
- 변경이 필요하면 `contracts/`를 먼저 업데이트한다.

### 3) QA 단계 (품질 게이트)
- `TEST_PLAN.md`를 만들고 최소 체크리스트를 확정한다.
- `QA_REPORT.md`로 이슈를 남기고, 가능하면 자동화 테스트를 추가한다.
 - 계약 불일치(contracts vs 구현)가 있으면 QA_REPORT에 “차단 이슈”로 등록한다.

### 4) 통합 요약
- 변경된 계약/가정/제약을 최종 요약한다.
- “다음 작업(스코프 확장)” 후보 3개를 제안한다.

## 금지 사항
- 계약이 없는 상태에서 무작정 구현을 밀어붙이지 않는다.
- 한 에이전트가 모든 결정을 독점하지 않는다(결정은 문서로 남긴다).

