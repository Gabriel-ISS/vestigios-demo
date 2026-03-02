extends Area2D

@export var comic_layer: ComicLayer
@export var comic_pages: Array[ComicPage]

var disabled = false

func _on_body_entered(body: Node2D) -> void:
	if disabled: return
	if body is Character:
		comic_layer.open_comic(comic_pages)
		disabled = true
