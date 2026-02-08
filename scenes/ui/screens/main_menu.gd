extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/screens/credits.tscn")

func _on_exit_pressed():
	get_tree().quit()
