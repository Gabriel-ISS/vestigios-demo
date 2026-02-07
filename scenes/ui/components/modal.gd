"""
Para usar esta escena simplemente hay que configurar
las variebles exportadas y cambiar su valor visible
cuando se desee ver.
Idealmente usarlo como PackedScene para agregarlo
al arbol de nodos solo cuando se necesite.
"""

class_name Modal extends CanvasLayer

@export var title = ''
@export var image: CompressedTexture2D = null
@export var description = ''
@export var show_cancel_button = false

@onready var _title: Label = $CenterContainer/Container/MarginContainer/Main/Title
@onready var _image: TextureRect = $CenterContainer/Container/MarginContainer/Main/Body/Image
@onready var _description: Label = $CenterContainer/Container/MarginContainer/Main/Body/Description
@onready var _cancel_button: Button = $CenterContainer/Container/MarginContainer/Main/Body/Buttons/CancelButton

signal confirm_presed
signal cancel_presed


func _ready() -> void:
	# Nos aseguramos de que no sea visible desde el principio
	#visible = false
	
	if title.length():
		_title.text = title
	else:
		_title.visible = false
	
	if image:
		_image.texture = image
	else:
		_image.visible = false
	
	if description.length():
		_description.text = description
	else:
		_description.visible = false

	_cancel_button.visible = show_cancel_button


func _on_confirm_button_pressed() -> void:
	visible = false
	confirm_presed.emit()


func _on_cancel_button_pressed() -> void:
	visible = false
	cancel_presed.emit()
