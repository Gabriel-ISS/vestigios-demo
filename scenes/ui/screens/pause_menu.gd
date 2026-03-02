extends Control

@onready var buttonsound = $VBoxContainer/buttonsound
@export var main_menu_scene: String = "res://MainMenu.tscn"

func _ready():
	# Comienza oculto
	visible = false
	# Permite procesar input aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event):
	# Presionando ESC activa o desactiva pausa
	if event.is_action_pressed("ui_cancel"):
		buttonsound.play()
		if visible:
			hide_pause()
		else:
			show_pause()

func show_pause():
	visible = true
	get_tree().paused = true

func hide_pause():
	visible = false
	get_tree().paused = false

# Señales de botones

func _on_resume_pressed():
	buttonsound.play()
	hide_pause()


func _on_main_menu_pressed():
	buttonsound.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/screens/main_menu.tscn")


func _on_exit_pressed():
	buttonsound.play()
	get_tree().quit()


func _on_pausebutton_pressed():
	buttonsound.play()
	var paused = get_tree().paused
	get_tree().paused = !paused
	visible = !paused
