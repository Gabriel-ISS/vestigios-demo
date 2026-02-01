extends Node2D

@onready var player_node: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mascara_coleccionable_closed(id: String, sender: Node2D) -> void:
	player_node.input_enabled = true

func _on_mascara_coleccionable_picked(id: String, sender: Node2D) -> void:
	player_node.input_enabled = false
