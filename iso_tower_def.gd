extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var building_layer: TileMapLayer = $BuildingLayer
@onready var camera: Camera2D = $Camera2D

# Our floor tile is Source 1, Atlas (7, 5) with alternates 1, 2, and 4 for variety
const FLOOR_TILE = {"source": 1, "coord": Vector2(7, 5), "alternates": [1, 2, 4]}

# Camera movement settings
const CAMERA_SPEED: float = 40.0  # Pixels per second
const DRAG_FACTOR: float = 0.15  # Multiplier for drag input
const CAMERA_SMOOTHING: float = 0.15  # Lower = smoother but slower

# Zoom settings
const ZOOM_SPEED: float = 0.1
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0
const ZOOM_SMOOTHING: float = 0.15

var target_camera_offset: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var target_zoom: Vector2 = Vector2.ONE

func generate_level() -> void:
		# For now we just generate a simple 256x256 level with our base floor tile
		for x in range(0, 256):
				for y in range(0, 256):
						ground_layer.set_cell(Vector2i(x, y), FLOOR_TILE.source, FLOOR_TILE.coord)
						ground_layer.set_cell(Vector2i(x, y), FLOOR_TILE.source, FLOOR_TILE.coord, FLOOR_TILE.alternates[randi() % FLOOR_TILE.alternates.size()])

func pan_camera(delta: Vector2) -> void:
		target_camera_offset += delta * CAMERA_SPEED

func _input(event: InputEvent) -> void:
		# Only handle drag input here
		if event.is_action_pressed("drag"):
				is_dragging = true
		elif event.is_action_released("drag"):
				is_dragging = false
		
		if is_dragging and event is InputEventMouseMotion:
				pan_camera(event.screen_relative * DRAG_FACTOR)

		# Handle zoom input
		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
						zoom_camera(-1)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
						zoom_camera(1)

func zoom_camera(zoom_factor: float) -> void:
		var new_zoom = target_zoom * (1.0 - zoom_factor * ZOOM_SPEED)
		# Clamp both x and y zoom values
		new_zoom.x = clamp(new_zoom.x, MIN_ZOOM, MAX_ZOOM)
		new_zoom.y = clamp(new_zoom.y, MIN_ZOOM, MAX_ZOOM)
		target_zoom = new_zoom

func _ready() -> void:
		generate_level()
		target_camera_offset = Vector2(128, 128)
		camera.offset = target_camera_offset
		target_zoom = camera.zoom
		print("Generated level.")

func _process(delta: float) -> void:
		# Handle keyboard input continuously
		var input_dir = Vector2.ZERO
		if Input.is_action_pressed("pan_left"):
				input_dir.x -= 1
		if Input.is_action_pressed("pan_right"):
				input_dir.x += 1
		if Input.is_action_pressed("pan_up"):
				input_dir.y -= 1
		if Input.is_action_pressed("pan_down"):
				input_dir.y += 1
		
		# Normalize diagonal movement
		if input_dir.length() > 0:
				input_dir = input_dir.normalized()
				pan_camera(input_dir * delta * CAMERA_SPEED)
		
		# Smoothly move the camera towards the target position
		camera.offset = camera.offset.lerp(target_camera_offset, CAMERA_SMOOTHING)
		
		# Smoothly interpolate zoom
		camera.zoom = camera.zoom.lerp(target_zoom, ZOOM_SMOOTHING)