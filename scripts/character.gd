extends CharacterBody2D

@export var speed = 400
@export var dead_screen: CanvasLayer

func _ready() -> void:
	position = Vector2(250, 250)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

@warning_ignore("unused_parameter")
func _physics_process(delta):
	get_input()
	move_and_slide()
