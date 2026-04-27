## AI Harness Template

이 저장소는 **하네스 엔지니어링(LLM + 하네스)** 을 프로젝트에 적용하기 위한 **범용 템플릿 레포**입니다.

### 하네스 구조

`.claude/` 아래에 다음이 들어있습니다.

- **`agents/`**: 팀(역할) 정의 (누가)
- **`skills/`**: 반복 워크플로/오케스트레이션 (어떻게)

추가로 `contracts/`는 **경계 계약(API/Data)** 을 고정하는 디렉터리입니다.

### 빠른 시작(새 프로젝트에 적용)

1) 이 레포를 GitHub에서 **Template repository**로 지정합니다.  
2) 새 프로젝트를 만들 때 **Use this template**로 레포를 생성합니다.  
3) `project-prd.md`를 채웁니다.  
4) `.claude/skills/project-orchestrator/SKILL.md` 순서대로 실행합니다.

### 포함된 템플릿 파일
- `project-prd.md`: PRD 템플릿
- `ARCHITECTURE.md`: 아키텍처/결정 로그
- `contracts/api.md`: API 계약(요청/응답/에러 규약)
- `contracts/data.md`: 데이터 계약(엔티티/규칙)
- `TEST_PLAN.md`, `QA_REPORT.md`: 품질 게이트 산출물 템플릿

### 레퍼런스
이 템플릿은 딩코딩코의 하네스 레포 구조를 참고했습니다.  
- `https://github.com/dingcodingco/youtube-minsim-with-harness`

