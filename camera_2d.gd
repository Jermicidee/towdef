extends Camera2D

const CAMERA_SPEED: float = 500.0
const CAMERA_SMOOTHING: float = 0.15
const ZOOM_SPEED: float = 0.1
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0
const ZOOM_SMOOTHING: float = 0.15

var target_offset: Vector2 = Vector2.ZERO
var target_zoom: Vector2 = Vector2.ONE
var is_dragging: bool = false

func _ready() -> void:
		target_offset = Vector2(128, 128)  # Center on level
		offset = target_offset
		target_zoom = zoom

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("drag"):
				is_dragging = true
		elif event.is_action_released("drag"):
				is_dragging = false
		
		if is_dragging and event is InputEventMouseMotion:
				target_offset -= event.relative

		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
						target_zoom *= 1.1
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
						target_zoom *= 0.9
				target_zoom = target_zoom.clamp(Vector2.ONE * MIN_ZOOM, Vector2.ONE * MAX_ZOOM)

func _process(_delta: float) -> void:
		var input_dir = Vector2.ZERO
		if Input.is_action_pressed("pan_left"): input_dir.x -= 1
		if Input.is_action_pressed("pan_right"): input_dir.x += 1
		if Input.is_action_pressed("pan_up"): input_dir.y -= 1
		if Input.is_action_pressed("pan_down"): input_dir.y += 1
		
		if input_dir.length() > 0:
				target_offset += input_dir.normalized() * CAMERA_SPEED * _delta

		offset = offset.lerp(target_offset, CAMERA_SMOOTHING)
		zoom = zoom.lerp(target_zoom, ZOOM_SMOOTHING)