extends CanvasLayer

@onready var button_sound: AudioStreamPlayer = $ButtonSound
@onready var menu_container: PanelContainer = $MenuContainer
@onready var pause_btn: TextureButton = $PauseBtn
@onready var resume_btn: Button = $MenuContainer/ButtonsContainer/ResumeBtn
@onready var main_menu_btn: Button = $MenuContainer/ButtonsContainer/MainMenuBtn
@onready var exit_btn: Button = $MenuContainer/ButtonsContainer/ExitBtn

@export var main_menu_scene: PackedScene

func _ready():
	# Comienza oculto
	menu_container.visible = false
	# Permite procesar input aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# conectar señales
	pause_btn.connect("pressed", pause)
	resume_btn.connect("pressed", resume)
	main_menu_btn.connect("pressed", go_to_main_menu)
	exit_btn.connect("pressed", exit_game)


func _unhandled_input(event):
	# Presionando ESC activa o desactiva pausa
	if event.is_action_pressed("ui_cancel"):
		if menu_container.visible:
			resume()
		else:
			pause()


func pause():
	button_sound.play()
	pause_btn.visible = false
	menu_container.visible = true
	get_tree().paused = true


func resume():
	button_sound.play()
	pause_btn.visible = true
	menu_container.visible = false
	get_tree().paused = false


func go_to_main_menu():
	button_sound.play()
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func exit_game():
	button_sound.play()
	get_tree().quit()
