extends Node2D

@export var SoverWorld: Texture2D
@export var SpriteGrande: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$SoverWorld.texture=SoverWorld
	$SpriteGrande.texture=SpriteGrande


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	$SoverWorld.visible=false
	$SpriteGrande.visible=true
