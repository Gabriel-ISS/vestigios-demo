class_name Dialog extends VBoxContainer

@onready var label: Label = $PanelContainer/MarginContainer/Label
@onready var timer: Timer = $Timer

var text:
	set(value):
		label.text = value
	get():
		return label.text

func _ready() -> void:
	visible = false

func show_dialog(text: String, duration: float):
	label.text = text
	visible = true
	timer.start(duration)


func _on_timer_timeout() -> void:
	visible = false
