extends Control

func _on_play_pressed():
	# Basicamente lo que hice aca es intentar no llamar la api
	# Cada rato, por las dudas
	var tree = get_tree()
	
	# Extraigo la escena actual para despues limpiar y pregargo el otro nivell
	var c_scene = tree.get_current_scene()
	var main_level = preload("res://scenes/main_level.tscn").instantiate()
	
	# Cargo el nodo en la raiz, quito la escena actual y le digo
	# al engine que me cambie de escena
	tree.get_root().add_child(main_level)
	tree.get_root().remove_child(c_scene)
	tree.set_current_scene(main_level)
	
	
# codigo kk 
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/screens/credits.tscn")

func _on_exit_pressed():
	get_tree().quit()
