class_name Character extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_screen: CanvasLayer = $DeadScreen
@onready var flashlight: PointLight2D = $Candle
@onready var dialog: Dialog = $Dialog
@onready var character_camera: Camera2D = $Camera2D

@export_category('Dependencies')
@export var speed = 400

@export_category('Camera')
@export var enable_character_camera: bool = true:
	set(value):
		enable_character_camera = value
		if is_node_ready():
			_apply_character_camera_state()

@export_category('Light offset')
@export var offset_up: Vector2 = Vector2(0, -20)
@export var offset_down: Vector2 = Vector2(0, 20)
@export var offset_left: Vector2 = Vector2(-20, 0)
@export var offset_right: Vector2 = Vector2(20, 0)

var last_direction := "down"

func _ready():
	dead_screen.visible = false
	update_animation("idle")
	update_flashlight()
	_apply_character_camera_state()

func _process(_delta):
	handle_animation()
	handle_input()
	move_and_slide()
	update_flashlight()

func handle_input():
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction.y = -1
	elif Input.is_action_pressed("down"):
		direction.y = 1
	elif Input.is_action_pressed("left"):
		direction.x = -1
	elif Input.is_action_pressed("right"):
		direction.x = 1
	
	velocity = direction * speed

func handle_animation():
	"""Esta función actualiza la animación en base a la velocidad del personaje.
	Siempre se debe ejecutar antes de establecer la animación del personaje."""
	
	if velocity == Vector2.ZERO:
		update_animation("idle")
		return
	
	if velocity.x > 0:
		last_direction = "right"
	elif velocity.x < 0:
		last_direction = "left"
	elif velocity.y > 0:
		last_direction = "down"
	elif velocity.y < 0:
		last_direction = "up"
	
	update_animation("walk")

func update_animation(state: String):
	var anim = state + "_" + last_direction
	if animated_sprite.animation != anim:
		animated_sprite.play(anim)

func update_flashlight():
	if flashlight == null:
		return

	var offset := Vector2.ZERO

	match last_direction:
		"up":
			offset = offset_up
		"down":
			offset = offset_down
		"left":
			offset = offset_left
		"right":
			offset = offset_right

	flashlight.global_position = global_position + offset

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/screens/main_menu.tscn")

func configure_external_camera(external_camera: Camera2D) -> void:
	if character_camera == null or external_camera == null:
		return

	_copy_camera_settings(character_camera, external_camera)

func _apply_character_camera_state() -> void:
	if character_camera == null:
		return

	character_camera.enabled = enable_character_camera
	if enable_character_camera:
		character_camera.make_current()

func _copy_camera_settings(source_camera: Camera2D, target_camera: Camera2D) -> void:
	var shared_properties: Array[StringName] = [
		&"offset",
		&"zoom",
		&"ignore_rotation",
		&"anchor_mode",
		&"drag_horizontal_enabled",
		&"drag_vertical_enabled",
		&"drag_left_margin",
		&"drag_right_margin",
		&"drag_top_margin",
		&"drag_bottom_margin",
		&"drag_horizontal_offset",
		&"drag_vertical_offset",
		&"position_smoothing_enabled",
		&"position_smoothing_speed",
		&"rotation_smoothing_enabled",
		&"rotation_smoothing_speed",
		&"process_callback"
	]

	for property_name in shared_properties:
		if _has_property(source_camera, property_name) and _has_property(target_camera, property_name):
			target_camera.set(property_name, source_camera.get(property_name))

func _has_property(target: Object, property_name: StringName) -> bool:
	for property_data in target.get_property_list():
		if property_data.name == property_name:
			return true

	return false
