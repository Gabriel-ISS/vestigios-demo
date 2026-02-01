extends CanvasLayer

signal closed

@onready var image_node: TextureRect = $Center/Panel/Padding/Content/Image
@onready var text_node: Label = $Center/Panel/Padding/Content/Text

@export var modal_image: Texture2D:
	set(value):
		modal_image = value
		image_node.texture = value

@export var modal_text: String = "":
	set(value):
		modal_text = value
		text_node.text = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if modal_image:
		image_node.texture = modal_image
	text_node.text = modal_text


func _on_button_pressed() -> void:
	visible = false
	emit_signal("closed")
