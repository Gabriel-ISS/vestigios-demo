extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 400
@export var dead_screen: CanvasLayer

# Linterna independiente
@export var flashlight: PointLight2D

# Offsets editables
@export var offset_up: Vector2 = Vector2(0, -20)
@export var offset_down: Vector2 = Vector2(0, 20)
@export var offset_left: Vector2 = Vector2(-20, 0)
@export var offset_right: Vector2 = Vector2(20, 0)

# Rotaciones editables
@export var rotation_up := -90
@export var rotation_down := 90
@export var rotation_left := 180
@export var rotation_right := 0

var last_direction := "down"

func _ready():
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
			rot = rotation_up
		"down":
			offset = offset_down
			rot = rotation_down
		"left":
			offset = offset_left
			rot = rotation_left
		"right":
			offset = offset_right
			rot = rotation_right

	flashlight.global_position = global_position + offset
	flashlight.rotation = deg_to_rad(rot)
