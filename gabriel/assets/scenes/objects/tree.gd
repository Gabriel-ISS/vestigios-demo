@tool

extends StaticBody2D

@export var version = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.region_rect = Rect2(128 * (version -1), 0, 128 * version, 512)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
