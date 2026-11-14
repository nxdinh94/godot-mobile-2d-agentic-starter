class_name Main
extends Node2D
## First scene: a tappable isometric tile grid that proves rendering, touch input
## and safe-area handling work on a phone. Replace with the real game later.

const GRID_SIZE: int = 7
const TILE_SIZE: Vector2 = Vector2(128.0, 64.0)
const COLOR_TILE_A: Color = Color("#3f7d5a")
const COLOR_TILE_B: Color = Color("#4a8f68")
const COLOR_SELECTED: Color = Color("#f2c94c")
const COLOR_OUTLINE: Color = Color("#1f3d2e")

var _selected: Vector2i = Vector2i(-1, -1)

@onready var _info: Label = %InfoLabel
@onready var _ui: MarginContainer = %SafeAreaRoot


func _ready() -> void:
	get_viewport().size_changed.connect(_layout)
	_layout()
	_update_info()


func _notification(what: int) -> void:
	# Android Back button: quit cleanly.
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()


func _process(_delta: float) -> void:
	_update_info()


func _unhandled_input(event: InputEvent) -> void:
	# Touch is emulated as mouse by default, so one handler covers phone and desktop.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cell: Vector2i = _screen_to_cell(to_local(event.position))
		_selected = cell if _in_grid(cell) else Vector2i(-1, -1)
		queue_redraw()


func _draw() -> void:
	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var cell := Vector2i(x, y)
			var color: Color = COLOR_TILE_A if (x + y) % 2 == 0 else COLOR_TILE_B
			if cell == _selected:
				color = COLOR_SELECTED
			var c: Vector2 = _cell_to_screen(cell)
			var pts := PackedVector2Array([
				c + Vector2(0.0, -TILE_SIZE.y * 0.5),
				c + Vector2(TILE_SIZE.x * 0.5, 0.0),
				c + Vector2(0.0, TILE_SIZE.y * 0.5),
				c + Vector2(-TILE_SIZE.x * 0.5, 0.0),
			])
			draw_colored_polygon(pts, color)
			draw_polyline(pts + PackedVector2Array([pts[0]]), COLOR_OUTLINE, 2.0)


func _cell_to_screen(cell: Vector2i) -> Vector2:
	return Vector2(
		(cell.x - cell.y) * TILE_SIZE.x * 0.5,
		(cell.x + cell.y) * TILE_SIZE.y * 0.5
	)


func _screen_to_cell(p: Vector2) -> Vector2i:
	var hx: float = p.x / (TILE_SIZE.x * 0.5)
	var hy: float = p.y / (TILE_SIZE.y * 0.5)
	return Vector2i(roundi((hy + hx) * 0.5), roundi((hy - hx) * 0.5))


func _in_grid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < GRID_SIZE and cell.y < GRID_SIZE


## Centers the grid in the viewport and keeps UI inside the notch/cutout safe area.
func _layout() -> void:
	var vp: Vector2 = get_viewport_rect().size
	var grid_height: float = GRID_SIZE * TILE_SIZE.y
	position = Vector2(vp.x * 0.5, vp.y * 0.5 - grid_height * 0.5 + TILE_SIZE.y * 0.5)

	var win: Vector2i = DisplayServer.window_get_size()
	var safe: Rect2i = DisplayServer.get_display_safe_area()
	if win.x > 0 and win.y > 0 and safe.size.x > 0 and safe.size.y > 0:
		var sx: float = vp.x / win.x
		var sy: float = vp.y / win.y
		_ui.add_theme_constant_override("margin_left", int(maxf(safe.position.x * sx, 16.0)))
		_ui.add_theme_constant_override("margin_top", int(maxf(safe.position.y * sy, 16.0)))
		_ui.add_theme_constant_override("margin_right", int(maxf((win.x - safe.end.x) * sx, 16.0)))


func _update_info() -> void:
	var sel: String = "none" if _selected.x < 0 else "%d, %d" % [_selected.x, _selected.y]
	_info.text = "my-game\nTap a tile\nSelected: %s\nFPS: %d" % [sel, Engine.get_frames_per_second()]
