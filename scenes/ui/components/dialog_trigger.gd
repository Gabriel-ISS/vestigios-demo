class_name DialogTrigger extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D

@export var dialog_text = ''
@export_range(1, 10) var duration = 1.0

# si se desactiva el dialog se mostrara cada vez que se entre en el area
@export var one_shot = true 

func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		if one_shot:
			queue_free()
		body.show_dialog(dialog_text, duration)
