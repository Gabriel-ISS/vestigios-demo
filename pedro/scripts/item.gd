extends Node2D

signal picked(id: String, sender: Node2D)
signal closed(id: String, sender: Node2D)

@export var item_id: String
@export var object_sprite: Texture2D
@export var modal_sprite: Texture2D
@export var modal_text: String
@export var max_sprite_size: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = object_sprite
	_apply_max_sprite_size()
	$PickedModal.modal_image = modal_sprite
	$PickedModal.modal_text = modal_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _apply_max_sprite_size() -> void:
	if max_sprite_size == Vector2.ZERO:
		return
	if $Sprite.texture == null:
		return
	var tex_size: Vector2 = $Sprite.texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return
	var scale_factor: float = min(
		max_sprite_size.x / tex_size.x,
		max_sprite_size.y / tex_size.y
	)
	scale_factor = min(scale_factor, 1.0)
	$Sprite.scale = Vector2(scale_factor, scale_factor)

func _on_area_2d_body_entered(body: Node2D) -> void:
	$PickedModal.show()
	picked.emit(item_id, self)


func _on_picked_modal_closed() -> void:
	closed.emit(item_id, self)
	queue_free()
