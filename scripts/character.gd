extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 400
@export var dead_screen: CanvasLayer

# Linterna independiente
@export var flashlight: PointLight2D

# Offsets editables por dirección
@export var offset_up: Vector2 = Vector2(0, -20)
@export var offset_down: Vector2 = Vector2(0, 20)
@export var offset_left: Vector2 = Vector2(-20, 0)
@export var offset_right: Vector2 = Vector2(20, 0)

# Rotaciones por dirección (en grados)
@export var rotation_up := -90
@export var rotation_down := 90
@export var rotation_left := 180
@export var rotation_right := 0

var last_direction := "up"

func _ready() -> void:
	position = Vector2(250, 250)
	update_animation("idle")
	update_flashlight()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	# IDLE
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("idle")
		update_flashlight()
		return

	# Determinar dirección principal
	if abs(input_direction.x) > abs(input_direction.y):
		last_direction = "right" if input_direction.x > 0 else "left"
	else:
		last_direction = "down" if input_direction.y > 0 else "up"

	velocity = input_direction * speed
	update_animation("walk")
	update_flashlight()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_flashlight() # asegura sincronía total

func update_animation(state: String):
	var anim_name = state + "_" + last_direction
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

func update_flashlight():
	if flashlight == null:
		return

	var offset := Vector2.ZERO
	var rot_deg := 0.0

	match last_direction:
		"up":
			offset = offset_up
			rot_deg = rotation_up
		"down":
			offset = offset_down
			rot_deg = rotation_down
		"left":
			offset = offset_left
			rot_deg = rotation_left
		"right":
			offset = offset_right
			rot_deg = rotation_right

	flashlight.global_position = global_position + offset
	flashlight.rotation = deg_to_rad(rot_deg)
