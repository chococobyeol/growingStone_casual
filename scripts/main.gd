extends Control

const SAVE_PATH := "user://save.json"
const SCREENSHOT_DIR := "user://screenshots"
const DISCOVERY_INTERVAL := 3600.0
const DEFAULT_WINDOW_SIZE := Vector2i(320, 420)
const MIN_WINDOW_SIZE := Vector2i(240, 320)
const MAX_WINDOW_SIZE := Vector2i(480, 640)

var StageView := preload("res://scripts/stage_view.gd")

var stone_catalog := [
	{"id": "agate", "name": "마노", "tags": ["다색", "광물", "줄무늬"], "rarity": "common"},
	{"id": "amethyst", "name": "자수정", "tags": ["보라", "보석", "결정"], "rarity": "rare"},
	{"id": "basalt", "name": "현무암", "tags": ["검정", "암석", "거침"], "rarity": "common"},
	{"id": "emerald", "name": "에메랄드", "tags": ["초록", "보석", "반짝임"], "rarity": "rare"},
	{"id": "granite", "name": "화강암", "tags": ["회색", "암석", "점무늬"], "rarity": "common"},
	{"id": "lapis", "name": "청금석", "tags": ["파랑", "광물", "반짝임"], "rarity": "rare"},
	{"id": "malachite", "name": "공작석", "tags": ["초록", "광물", "줄무늬"], "rarity": "uncommon"},
	{"id": "obsidian", "name": "흑요석", "tags": ["검정", "암석", "반짝임"], "rarity": "uncommon"},
	{"id": "pyrite", "name": "황철석", "tags": ["노랑", "광물", "금속성"], "rarity": "uncommon"},
	{"id": "quartz", "name": "석영", "tags": ["투명", "광물", "결정"], "rarity": "common"}
]

var decoration_catalog := [
	{"id": "wood", "name": "원목 받침", "layer": "pedestal", "rarity": "common"},
	{"id": "plate", "name": "작은 접시", "layer": "pedestal", "rarity": "common"},
	{"id": "pot", "name": "미니 화분", "layer": "pedestal", "rarity": "uncommon"},
	{"id": "moon_stand", "name": "달빛 받침대", "layer": "pedestal", "rarity": "rare"},
	{"id": "cushion", "name": "납작한 쿠션", "layer": "pedestal", "rarity": "common"},
	{"id": "glass_dome", "name": "유리 돔", "layer": "case", "rarity": "rare"},
	{"id": "shelf", "name": "작은 진열장", "layer": "case", "rarity": "common"},
	{"id": "mini_shelf", "name": "미니 선반", "layer": "case", "rarity": "common"},
	{"id": "wood_box", "name": "나무 상자", "layer": "case", "rarity": "uncommon"},
	{"id": "specimen", "name": "표본 케이스", "layer": "case", "rarity": "uncommon"},
	{"id": "window", "name": "창가 배경", "layer": "background", "rarity": "common"},
	{"id": "sand", "name": "모래 정원 배경", "layer": "background", "rarity": "uncommon"},
	{"id": "plain", "name": "단색 배경", "layer": "background", "rarity": "common"},
	{"id": "note", "name": "노트 배경", "layer": "background", "rarity": "common"},
	{"id": "stars", "name": "별빛 배경", "layer": "background", "rarity": "rare"},
	{"id": "crown", "name": "작은 왕관", "layer": "accessory_1", "rarity": "rare"},
	{"id": "ribbon", "name": "리본", "layer": "accessory_1", "rarity": "common"},
	{"id": "sprout", "name": "새싹 장식", "layer": "accessory_1", "rarity": "common"},
	{"id": "hat", "name": "작은 모자", "layer": "accessory_1", "rarity": "uncommon"},
	{"id": "moon", "name": "달 조각", "layer": "accessory_1", "rarity": "rare"},
	{"id": "glasses", "name": "안경", "layer": "accessory_2", "rarity": "common"},
	{"id": "sunglasses", "name": "선글라스", "layer": "accessory_2", "rarity": "uncommon"},
	{"id": "bandage", "name": "반창고", "layer": "accessory_2", "rarity": "common"},
	{"id": "blush", "name": "볼터치", "layer": "accessory_2", "rarity": "common"},
	{"id": "mustache", "name": "작은 콧수염", "layer": "accessory_2", "rarity": "rare"},
	{"id": "nameplate", "name": "미니 명패", "layer": "accessory_3", "rarity": "common"},
	{"id": "flag", "name": "작은 깃발", "layer": "accessory_3", "rarity": "common"},
	{"id": "sticker", "name": "스티커", "layer": "accessory_3", "rarity": "common"},
	{"id": "star_sticker", "name": "별 스티커", "layer": "accessory_3", "rarity": "uncommon"},
	{"id": "season", "name": "계절 장식", "layer": "accessory_3", "rarity": "rare"}
]

var state := {
	"active_seconds": 0.0,
	"discovery_elapsed": 0.0,
	"stone_name": "작은 돌",
	"discovered_stones": [],
	"discovered_decorations": [],
	"loadout": {
		"background": "",
		"case": "",
		"pedestal": "",
		"accessory_1": "",
		"accessory_2": "",
		"accessory_3": ""
	},
	"window_size": [320, 420],
	"always_on_top": true,
	"last_discovery": ""
}

var stage_view: Control
var status_label: Label
var discovery_label: Label
var count_label: Label
var content: VBoxContainer
var save_accumulator := 0.0
var current_tab := "home"
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	_load_game()
	_apply_window_settings()
	_build_ui()
	_refresh_all()

func _process(delta: float) -> void:
	state.active_seconds += delta
	state.discovery_elapsed += delta
	while state.discovery_elapsed >= DISCOVERY_INTERVAL:
		state.discovery_elapsed -= DISCOVERY_INTERVAL
		_discover_next()
	save_accumulator += delta
	if save_accumulator >= 5.0:
		save_accumulator = 0.0
		_save_game()
	_refresh_status()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_store_window_state()
		_save_game()

func _build_ui() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 6)
	root.offset_left = 10
	root.offset_top = 8
	root.offset_right = -10
	root.offset_bottom = -8
	add_child(root)

	var title := Label.new()
	title.text = "돌 키우기"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 18)
	root.add_child(title)

	stage_view = StageView.new()
	stage_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(stage_view)

	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(status_label)

	discovery_label = Label.new()
	discovery_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(discovery_label)

	count_label = Label.new()
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(count_label)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 4)
	root.add_child(tabs)
	_add_tab_button(tabs, "홈", "home")
	_add_tab_button(tabs, "도감", "catalog")
	_add_tab_button(tabs, "꾸미기", "decorate")
	_add_tab_button(tabs, "설정", "settings")

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 92)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 6)
	scroll.add_child(content)

func _add_tab_button(parent: HBoxContainer, label: String, tab_name: String) -> void:
	var button := Button.new()
	button.text = label
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func() -> void:
		current_tab = tab_name
		_refresh_tab()
	)
	parent.add_child(button)

func _refresh_all() -> void:
	var size_multiplier := _size_multiplier()
	stage_view.set_stage(size_multiplier, state.loadout)
	_refresh_status()
	_refresh_tab()

func _refresh_status() -> void:
	var size_multiplier := _size_multiplier()
	status_label.text = "%s  %.2fx  실행 %s" % [state.stone_name, size_multiplier, _format_time(state.active_seconds)]
	var remaining: float = max(0.0, DISCOVERY_INTERVAL - float(state.discovery_elapsed))
	discovery_label.text = "다음 도감 발견까지 %s" % _format_time(remaining)
	count_label.text = "도감 %d/%d" % [_discovered_count(), _total_catalog_count()]
	if is_instance_valid(stage_view):
		stage_view.set_stage(size_multiplier, state.loadout)

func _refresh_tab() -> void:
	for child in content.get_children():
		child.queue_free()
	if current_tab == "home":
		_build_home_tab()
	elif current_tab == "catalog":
		_build_catalog_tab()
	elif current_tab == "decorate":
		_build_decorate_tab()
	elif current_tab == "settings":
		_build_settings_tab()

func _build_home_tab() -> void:
	var last := Label.new()
	last.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if str(state.last_discovery) == "":
		last.text = "게임을 켜두면 돌이 커집니다. 첫 도감 발견은 1시간 후입니다."
	else:
		last.text = "최근 발견: %s" % state.last_discovery
	content.add_child(last)

	var shot := Button.new()
	shot.text = "스크린샷 저장"
	shot.pressed.connect(_save_screenshot)
	content.add_child(shot)

	var save_now := Button.new()
	save_now.text = "저장"
	save_now.pressed.connect(func() -> void:
		_store_window_state()
		_save_game()
		state.last_discovery = "저장 완료"
		_refresh_tab()
	)
	content.add_child(save_now)

func _build_catalog_tab() -> void:
	var stone_header := Label.new()
	stone_header.text = "돌 도감"
	stone_header.add_theme_font_size_override("font_size", 15)
	content.add_child(stone_header)
	for item in stone_catalog:
		content.add_child(_catalog_label(item, state.discovered_stones.has(item.id), "tags"))

	var deco_header := Label.new()
	deco_header.text = "꾸미기 도감"
	deco_header.add_theme_font_size_override("font_size", 15)
	content.add_child(deco_header)
	for item in decoration_catalog:
		content.add_child(_catalog_label(item, state.discovered_decorations.has(item.id), "layer"))

func _catalog_label(item: Dictionary, discovered: bool, meta_key: String) -> Label:
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if discovered:
		var meta = item.get(meta_key, "")
		if meta is Array:
			meta = ", ".join(meta)
		label.text = "✓ %s  [%s]" % [item.name, meta]
	else:
		label.text = "? 미발견"
	return label

func _build_decorate_tab() -> void:
	_add_layer_picker("배경", "background")
	_add_layer_picker("장식장", "case")
	_add_layer_picker("받침", "pedestal")
	_add_layer_picker("액세서리 1", "accessory_1")
	_add_layer_picker("액세서리 2", "accessory_2")
	_add_layer_picker("액세서리 3", "accessory_3")

func _add_layer_picker(label_text: String, layer: String) -> void:
	var label := Label.new()
	label.text = label_text
	content.add_child(label)
	var options := OptionButton.new()
	options.add_item("없음")
	options.set_item_metadata(0, "")
	var selected := 0
	for item in decoration_catalog:
		if item.layer != layer:
			continue
		if not state.discovered_decorations.has(item.id):
			continue
		options.add_item(item.name)
		var index := options.item_count - 1
		options.set_item_metadata(index, item.id)
		if state.loadout.get(layer, "") == item.id:
			selected = index
	options.select(selected)
	options.item_selected.connect(func(index: int) -> void:
		state.loadout[layer] = str(options.get_item_metadata(index))
		_save_game()
		_refresh_all()
	)
	content.add_child(options)

func _build_settings_tab() -> void:
	var info := Label.new()
	info.text = "창 크기와 항상 위 표시"
	content.add_child(info)

	var size_row := HBoxContainer.new()
	content.add_child(size_row)
	var smaller := Button.new()
	smaller.text = "-"
	smaller.pressed.connect(func() -> void: _resize_window(-40))
	size_row.add_child(smaller)
	var bigger := Button.new()
	bigger.text = "+"
	bigger.pressed.connect(func() -> void: _resize_window(40))
	size_row.add_child(bigger)

	var top := CheckBox.new()
	top.text = "항상 위"
	top.button_pressed = bool(state.always_on_top)
	top.toggled.connect(func(enabled: bool) -> void:
		state.always_on_top = enabled
		_apply_window_settings()
		_save_game()
	)
	content.add_child(top)

	var ai := Label.new()
	ai.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ai.text = "AI 대화는 출시 후 후보 기능입니다. 기본적으로 돌은 대사하지 않습니다."
	content.add_child(ai)

func _discover_next() -> void:
	var pool := []
	for item in stone_catalog:
		if not state.discovered_stones.has(item.id):
			pool.append({"type": "stone", "item": item})
	for item in decoration_catalog:
		if not state.discovered_decorations.has(item.id):
			pool.append({"type": "decoration", "item": item})
	if pool.is_empty():
		state.last_discovery = "발견 가능한 도감 항목이 없습니다."
		return
	var pick: Dictionary = pool[rng.randi_range(0, pool.size() - 1)]
	var item: Dictionary = pick["item"]
	if pick["type"] == "stone":
		state.discovered_stones.append(item["id"])
		state.last_discovery = "새 돌: %s" % item["name"]
	else:
		state.discovered_decorations.append(item["id"])
		state.last_discovery = "새 꾸미기: %s" % item["name"]
		if state.loadout.get(item["layer"], "") == "":
			state.loadout[item["layer"]] = item["id"]
	_save_game()
	_refresh_all()

func _size_multiplier() -> float:
	return 1.0 + 0.35 * log(1.0 + float(state.active_seconds) / 1800.0)

func _format_time(seconds: float) -> String:
	var total := int(max(0.0, seconds))
	var hours := floori(float(total) / 3600.0)
	var minutes := floori(float(total % 3600) / 60.0)
	var secs := total % 60
	if hours > 0:
		return "%d시간 %02d분" % [hours, minutes]
	return "%02d:%02d" % [minutes, secs]

func _discovered_count() -> int:
	return state.discovered_stones.size() + state.discovered_decorations.size()

func _total_catalog_count() -> int:
	return stone_catalog.size() + decoration_catalog.size()

func _save_screenshot() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SCREENSHOT_DIR))
	var image := get_viewport().get_texture().get_image()
	var file_name := "stone_%s.png" % Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s/%s" % [SCREENSHOT_DIR, file_name]
	image.save_png(path)
	state.last_discovery = "스크린샷 저장: %s" % ProjectSettings.globalize_path(path)
	_refresh_tab()

func _resize_window(delta: int) -> void:
	var current := DisplayServer.window_get_size()
	var next := Vector2i(
		clamp(current.x + delta, MIN_WINDOW_SIZE.x, MAX_WINDOW_SIZE.x),
		clamp(current.y + int(delta * 1.25), MIN_WINDOW_SIZE.y, MAX_WINDOW_SIZE.y)
	)
	state.window_size = [next.x, next.y]
	_apply_window_settings()
	_save_game()

func _apply_window_settings() -> void:
	var window_size := Vector2i(int(state.window_size[0]), int(state.window_size[1]))
	window_size.x = clamp(window_size.x, MIN_WINDOW_SIZE.x, MAX_WINDOW_SIZE.x)
	window_size.y = clamp(window_size.y, MIN_WINDOW_SIZE.y, MAX_WINDOW_SIZE.y)
	DisplayServer.window_set_size(window_size)
	DisplayServer.window_set_min_size(MIN_WINDOW_SIZE)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, bool(state.always_on_top))

func _store_window_state() -> void:
	var current_window_size := DisplayServer.window_get_size()
	state.window_size = [current_window_size.x, current_window_size.y]

func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return
	for key in parsed.keys():
		if state.has(key):
			state[key] = parsed[key]
	_ensure_state_shape()

func _ensure_state_shape() -> void:
	for key in ["background", "case", "pedestal", "accessory_1", "accessory_2", "accessory_3"]:
		if not state.loadout.has(key):
			state.loadout[key] = ""
	if not state.has("window_size") or state.window_size.size() != 2:
		state.window_size = [DEFAULT_WINDOW_SIZE.x, DEFAULT_WINDOW_SIZE.y]

func _save_game() -> void:
	_store_window_state()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(state, "\t"))
