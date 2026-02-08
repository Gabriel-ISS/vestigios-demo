class_name Character extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_screen: CanvasLayer = $DeadScreen
@onready var flashlight: PointLight2D = $Candle
@onready var dialog: Dialog = $Dialog 

@export_category('Dependencies')
@export var speed = 400

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

func _physics_process(_delta):
	handle_input()
	move_and_slide()
	update_flashlight()

func handle_input():
	var direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		direction.y = -1
		last_direction = "up"
	elif Input.is_action_pressed("down"):
		direction.y = 1
		last_direction = "down"
	elif Input.is_action_pressed("left"):
		direction.x = -1
		last_direction = "left"
	elif Input.is_action_pressed("right"):
		direction.x = 1
		last_direction = "right"

	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("idle")
	else:
		velocity = direction * speed
		update_animation("walk")

func update_animation(state: String):
	var anim = state + "_" + last_direction
	if animated_sprite.animation != anim:
		animated_sprite.play(anim)

func update_flashlight():
	if flashlight == null:
		return

	var offset := Vector2.ZERO
	var rot := 0.0

	match last_direction:
		"up":
			offset = offset_up
			rot = -90
		"down":
			offset = offset_down
			rot = 90
		"left":
			offset = offset_left
			rot = 180
		"right":
			offset = offset_right
			rot = 0

	flashlight.global_position = global_position + offset
	flashlight.rotation = deg_to_rad(rot)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/screens/main_menu.tscn")

func show_dialog(text: String, duration: int):
	dialog.show_dialog(text, duration)
