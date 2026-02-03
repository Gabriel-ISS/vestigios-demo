extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Iván/Scenes/control_credits.tscn")

func _on_exit_pressed():
	get_tree().quit()
