extends Control


# Función que se llamará desde el botón conectado
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Iván/Scripts/main_menu.tscn")
