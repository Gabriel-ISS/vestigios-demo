extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction = Vector2(0, 0)
	
	if Input.is_action_pressed("up"):
		direction.y = -1
	elif Input.is_action_pressed("down"):
		direction.y = 1
	elif Input.is_action_pressed("left"):
		direction.x = -1
	elif Input.is_action_pressed("right"):
		direction.x = 1
	
	velocity = direction * SPEED
	move_and_slide()
