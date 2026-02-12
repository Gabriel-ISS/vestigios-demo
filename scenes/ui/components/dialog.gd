class_name Dialog extends CanvasLayer

@onready var label: Label = $DialogBox/MarginContainer/MarginContainer/Label
@onready var timer: Timer = $Timer
@onready var parent: Node2D = get_parent()
@onready var box: Control = $DialogBox

@export var dialog_offset = Vector2(30, -90)

var text:
	set(value):
		label.text = value
	get():
		return label.text

func _ready() -> void:
	visible = false
	box.position = parent.global_position

func _process(_delta: float) -> void:
	var pos_local = dialog_offset
	var transform_canvas = parent.get_global_transform_with_canvas()
	var pos_canvas = transform_canvas * pos_local
	
	box.position.x = pos_canvas.x
	box.position.y = pos_canvas.y - box.size.y

func show_dialog(text: String, duration: float):
	label.text = text
	visible = true
	timer.start(duration)

func _on_timer_timeout() -> void:
	visible = false
