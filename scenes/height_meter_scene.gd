extends Node2D

const TILE_SIZE = 16.0

@onready var player = $Player

var minX = 0.0
var maxX = ProjectSettings.get_setting("display/window/size/viewport_width")


func _physics_process(delta: float):
    var pos: Vector2 = player.position

    if pos.x < minX:
        player.position.x = maxX - TILE_SIZE
    elif pos.x > maxX:
        player.position.x = minX + TILE_SIZE
