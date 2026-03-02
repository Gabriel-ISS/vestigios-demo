extends Control

@onready var buttonsound = $buttonsound

func _on_button_pressed() -> void:
	buttonsound.play()
	get_tree().change_scene_to_file("res://scenes/ui/screens/main_menu.tscn")
