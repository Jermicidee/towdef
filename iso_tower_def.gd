extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var building_layer: TileMapLayer = $BuildingLayer
@onready var camera: Camera2D = $Camera2D

# Our floor tile is Source 1, Atlas (7, 5) with alternates 1, 2, and 4 for variety
const FLOOR_TILE = {"source": 1, "coord": Vector2(7, 5), "alternates": [1, 2, 4]}

func generate_level() -> void:
    # For now we just generate a simple 256x256 level with our base floor tile
    for x in range(0, 256):
        for y in range(0, 256):
            ground_layer.set_cell(Vector2i(x, y), FLOOR_TILE.source, FLOOR_TILE.coord)
            ground_layer.set_cell(Vector2i(x, y), FLOOR_TILE.source, FLOOR_TILE.coord, FLOOR_TILE.alternates[randi() % FLOOR_TILE.alternates.size()])

func _ready() -> void:
    generate_level()
    print("Generated level.")