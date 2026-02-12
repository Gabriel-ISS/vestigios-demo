extends Control

@onready var button_sound = $OptionsPadding/Options/buttonsound

func _on_play_pressed():
	button_sound.play()
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_credits_pressed():
	button_sound.play()
	get_tree().change_scene_to_file("res://scenes/ui/screens/credits.tscn")

func _on_exit_pressed():
	button_sound.play()
	get_tree().quit()
