## Data Contracts

`돌 키우기`는 첫 출시 버전에서 서버를 사용하지 않는다. 모든 상태는 로컬 세이브 파일 `user://save.json`에 저장한다.

### Save File

```json
{
  "active_seconds": 0.0,
  "discovery_elapsed": 0.0,
  "stone_name": "작은 돌",
  "discovered_stones": ["agate"],
  "discovered_decorations": ["plain", "wood"],
  "loadout": {
    "background": "plain",
    "case": "",
    "pedestal": "wood",
    "accessory_1": "",
    "accessory_2": "",
    "accessory_3": ""
  },
  "window_size": [320, 420],
  "widget_window_size": [320, 420],
  "always_on_top": true,
  "last_discovery": ""
}
```

### 규칙

- `active_seconds`: 게임이 켜져 있던 누적 시간이다. 게임이 꺼진 시간은 포함하지 않는다.
- `discovery_elapsed`: 다음 도감 발견까지 누적된 실행 시간이다.
- `discovered_stones`: 돌 도감에 등록된 돌 ID 목록이다.
- `discovered_decorations`: 꾸미기 도감에 등록된 꾸미기 아이템 ID 목록이다.
- `loadout`: 현재 장착한 꾸미기 레이어 상태다.
- `window_size`: 기존 저장 호환용 창 크기다.
- `widget_window_size`: 돌만 보이는 기본 위젯 화면의 창 크기다.
- `always_on_top`: 항상 위 표시 여부다. 기본값은 `true`다.
- 관리 화면 크기는 저장하지 않는다. 관리 화면은 고정 권장 크기 `760x720px`로 열린다.

### Catalog Entry

돌 도감 항목:

```json
{
  "id": "amethyst",
  "name": "자수정",
  "tags": ["보라", "보석", "결정"],
  "rarity": "rare"
}
```

꾸미기 도감 항목:

```json
{
  "id": "glass_dome",
  "name": "유리 돔",
  "layer": "case",
  "rarity": "rare"
}
```

### Discovery

- 1시간마다 도감 발견 판정을 수행한다.
- 이미 등록된 도감 항목은 후보에서 제외한다.
- 후보가 없으면 발견 이벤트를 발생시키지 않는다.
- 발견된 꾸미기 항목의 레이어가 비어 있으면 자동 장착할 수 있다.
