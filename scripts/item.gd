extends Node2D

signal picked(id: String, sender: Node2D)
signal closed(id: String, sender: Node2D)

@export var item_id: String
@export var object_sprite: Texture2D
@export var modal_sprite: Texture2D
@export var modal_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("modal_text", modal_text)
	$Sprite.texture = object_sprite
	$PickedModal.modal_image = modal_sprite
	$PickedModal.modal_text = modal_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	$PickedModal.show()
	picked.emit(item_id, self)


func _on_picked_modal_closed() -> void:
	closed.emit(item_id, self)
	queue_free()
