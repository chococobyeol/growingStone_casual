extends Control

var size_multiplier: float = 1.0
var decoration_loadout: Dictionary = {}

func _ready() -> void:
	custom_minimum_size = Vector2(260, 210)

func set_stage(new_size_multiplier: float, new_loadout: Dictionary) -> void:
	size_multiplier = new_size_multiplier
	decoration_loadout = new_loadout.duplicate(true)
	queue_redraw()

func _draw() -> void:
	var rect := get_rect()
	var w := rect.size.x
	var h := rect.size.y
	_draw_background(w, h)
	_draw_case(w, h)
	_draw_pedestal(w, h)
	_draw_stone(w, h)
	_draw_accessories(w, h)

func _draw_background(w: float, h: float) -> void:
	var id := str(decoration_loadout.get("background", ""))
	var color := Color("#f4eadc")
	if id == "window":
		color = Color("#e7f3fb")
	elif id == "sand":
		color = Color("#efe3c6")
	elif id == "plain":
		color = Color("#f7f4ee")
	elif id == "note":
		color = Color("#fff7c7")
	elif id == "stars":
		color = Color("#20243a")
	draw_rect(Rect2(Vector2.ZERO, Vector2(w, h)), color)
	if id == "window":
		draw_rect(Rect2(Vector2(w * 0.12, h * 0.12), Vector2(w * 0.76, h * 0.36)), Color("#fffdf7"), false, 3)
		draw_line(Vector2(w * 0.5, h * 0.12), Vector2(w * 0.5, h * 0.48), Color("#fffdf7"), 2)
	elif id == "note":
		for y in range(28, int(h), 22):
			draw_line(Vector2(0, y), Vector2(w, y), Color("#eadf93"), 1)
	elif id == "stars":
		for p in [Vector2(42, 36), Vector2(95, 68), Vector2(170, 42), Vector2(235, 84)]:
			draw_circle(p, 2.0, Color("#f8e88a"))

func _draw_case(w: float, h: float) -> void:
	var id := str(decoration_loadout.get("case", ""))
	if id == "":
		return
	var center := Vector2(w * 0.5, h * 0.58)
	if id == "glass_dome":
		draw_arc(center, w * 0.34, PI, TAU, 48, Color("#d5f0ff"), 5)
		draw_line(center + Vector2(-w * 0.34, 0), center + Vector2(w * 0.34, 0), Color("#d5f0ff"), 5)
	elif id == "shelf":
		draw_rect(Rect2(Vector2(w * 0.18, h * 0.18), Vector2(w * 0.64, h * 0.66)), Color("#b9875b"), false, 5)
		draw_line(Vector2(w * 0.18, h * 0.52), Vector2(w * 0.82, h * 0.52), Color("#b9875b"), 5)
	elif id == "mini_shelf":
		draw_line(Vector2(w * 0.22, h * 0.72), Vector2(w * 0.78, h * 0.72), Color("#8d6548"), 8)
	elif id == "wood_box":
		draw_rect(Rect2(Vector2(w * 0.15, h * 0.28), Vector2(w * 0.7, h * 0.58)), Color("#c89a6d"), false, 6)
	elif id == "specimen":
		draw_rect(Rect2(Vector2(w * 0.18, h * 0.2), Vector2(w * 0.64, h * 0.68)), Color("#e4ddd1"), false, 5)
		draw_circle(Vector2(w * 0.5, h * 0.16), 5, Color("#b9a98f"))

func _draw_pedestal(w: float, h: float) -> void:
	var id := str(decoration_loadout.get("pedestal", ""))
	var y := h * 0.78
	var color := Color("#c7a26d")
	if id == "plate":
		color = Color("#e8dfcf")
	elif id == "pot":
		color = Color("#bf7c4f")
	elif id == "moon_stand":
		color = Color("#d8d5ef")
	elif id == "cushion":
		color = Color("#eab0bd")
	draw_ellipse(Vector2(w * 0.5, y), Vector2(w * 0.31, h * 0.055), color, Color("#3d3a36"), 3)
	if id == "pot":
		draw_rect(Rect2(Vector2(w * 0.36, h * 0.73), Vector2(w * 0.28, h * 0.09)), color)

func _draw_stone(w: float, h: float) -> void:
	var base: float = 58.0
	var radius: float = minf(base * size_multiplier, minf(w, h) * 0.36)
	var center: Vector2 = Vector2(w * 0.5, h * 0.61)
	var points := PackedVector2Array([
		center + Vector2(-radius * 0.78, -radius * 0.06),
		center + Vector2(-radius * 0.56, -radius * 0.46),
		center + Vector2(-radius * 0.08, -radius * 0.62),
		center + Vector2(radius * 0.52, -radius * 0.44),
		center + Vector2(radius * 0.78, -radius * 0.04),
		center + Vector2(radius * 0.56, radius * 0.43),
		center + Vector2(-radius * 0.08, radius * 0.56),
		center + Vector2(-radius * 0.64, radius * 0.34)
	])
	draw_colored_polygon(points, Color("#9da3a6"))
	for i in range(points.size()):
		draw_line(points[i], points[(i + 1) % points.size()], Color("#2e3033"), 4)
	draw_arc(center + Vector2(-radius * 0.16, -radius * 0.16), radius * 0.28, PI * 1.05, PI * 1.75, 20, Color("#f5f8fa"), 4)
	draw_circle(center + Vector2(radius * 0.28, radius * 0.05), max(3, radius * 0.06), Color("#737b80"))

func _draw_accessories(w: float, h: float) -> void:
	var center: Vector2 = Vector2(w * 0.5, h * 0.61)
	var radius: float = minf(58.0 * size_multiplier, minf(w, h) * 0.36)
	_draw_accessory(str(decoration_loadout.get("accessory_1", "")), center, radius, 1)
	_draw_accessory(str(decoration_loadout.get("accessory_2", "")), center, radius, 2)
	_draw_accessory(str(decoration_loadout.get("accessory_3", "")), center, radius, 3)

func _draw_accessory(id: String, center: Vector2, radius: float, _slot: int) -> void:
	if id == "":
		return
	if id == "crown":
		var top := center + Vector2(0, -radius * 0.72)
		draw_colored_polygon(PackedVector2Array([
			top + Vector2(-24, 12), top + Vector2(-14, -10), top + Vector2(0, 10),
			top + Vector2(14, -10), top + Vector2(24, 12)
		]), Color("#f4c542"))
		draw_polyline(PackedVector2Array([
			top + Vector2(-24, 12), top + Vector2(-14, -10), top + Vector2(0, 10),
			top + Vector2(14, -10), top + Vector2(24, 12)
		]), Color("#4b3d12"), 3)
	elif id == "ribbon":
		var p := center + Vector2(-radius * 0.54, -radius * 0.25)
		draw_circle(p + Vector2(-10, 0), 12, Color("#e85e85"))
		draw_circle(p + Vector2(10, 0), 12, Color("#e85e85"))
		draw_circle(p, 6, Color("#b7355c"))
	elif id == "sprout":
		var p2 := center + Vector2(0, -radius * 0.68)
		draw_line(p2, p2 + Vector2(0, -20), Color("#4f9b54"), 4)
		draw_circle(p2 + Vector2(-9, -17), 9, Color("#78c36d"))
		draw_circle(p2 + Vector2(9, -17), 9, Color("#78c36d"))
	elif id == "hat":
		var p3 := center + Vector2(0, -radius * 0.62)
		draw_rect(Rect2(p3 + Vector2(-28, -8), Vector2(56, 10)), Color("#33343a"))
		draw_rect(Rect2(p3 + Vector2(-18, -32), Vector2(36, 26)), Color("#3f4148"))
	elif id == "moon":
		var p4 := center + Vector2(radius * 0.45, -radius * 0.5)
		draw_circle(p4, 15, Color("#efe6aa"))
		draw_circle(p4 + Vector2(7, -2), 15, Color("#f4eadc"))
	elif id == "glasses":
		var p5 := center + Vector2(0, -radius * 0.12)
		draw_circle(p5 + Vector2(-20, 0), 13, Color("#222222"), false, 3)
		draw_circle(p5 + Vector2(20, 0), 13, Color("#222222"), false, 3)
		draw_line(p5 + Vector2(-7, 0), p5 + Vector2(7, 0), Color("#222222"), 3)
	elif id == "sunglasses":
		var p6 := center + Vector2(0, -radius * 0.12)
		draw_rect(Rect2(p6 + Vector2(-36, -10), Vector2(28, 18)), Color("#111111"))
		draw_rect(Rect2(p6 + Vector2(8, -10), Vector2(28, 18)), Color("#111111"))
		draw_line(p6 + Vector2(-8, -1), p6 + Vector2(8, -1), Color("#111111"), 3)
	elif id == "bandage":
		draw_rect(Rect2(center + Vector2(-28, -6), Vector2(56, 12)), Color("#f1d7b5"))
	elif id == "blush":
		draw_circle(center + Vector2(-radius * 0.35, radius * 0.12), 9, Color("#e999a7"))
		draw_circle(center + Vector2(radius * 0.35, radius * 0.12), 9, Color("#e999a7"))
	elif id == "mustache":
		var p7 := center + Vector2(0, radius * 0.08)
		draw_circle(p7 + Vector2(-10, 0), 10, Color("#28221d"))
		draw_circle(p7 + Vector2(10, 0), 10, Color("#28221d"))
	elif id == "nameplate":
		draw_rect(Rect2(center + Vector2(-38, radius * 0.72), Vector2(76, 20)), Color("#d8b16a"))
	elif id == "flag":
		var p8 := center + Vector2(radius * 0.62, -radius * 0.1)
		draw_line(p8, p8 + Vector2(0, -42), Color("#5d4a35"), 4)
		draw_colored_polygon(PackedVector2Array([p8 + Vector2(0, -42), p8 + Vector2(32, -32), p8 + Vector2(0, -22)]), Color("#e05a4f"))
	elif id == "sticker":
		draw_circle(center + Vector2(-radius * 0.2, radius * 0.1), 11, Color("#ffe08a"))
	elif id == "star_sticker":
		draw_circle(center + Vector2(radius * 0.24, -radius * 0.1), 11, Color("#f4d24d"))
	elif id == "season":
		draw_circle(center + Vector2(radius * 0.42, radius * 0.22), 10, Color("#f27c4f"))

func draw_ellipse(center: Vector2, radii: Vector2, fill: Color, outline: Color, width: float) -> void:
	var pts := PackedVector2Array()
	for i in range(48):
		var angle := TAU * float(i) / 48.0
		pts.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(pts, fill)
	for i in range(pts.size()):
		draw_line(pts[i], pts[(i + 1) % pts.size()], outline, width)
