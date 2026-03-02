extends Node2D

@onready var detective: CharacterBody2D = $Detective
@onready var level_camera: Camera2D = $LevelCamera2D

var camera_offset_tween: Tween
const CAMERA_SHIFT_LERP_SECONDS := 0.3

func _ready() -> void:
	_sync_level_camera_from_character_camera()
	_update_camera_mode()

func _physics_process(_delta: float) -> void:
	if level_camera == null or detective == null:
		return

	level_camera.global_position = detective.global_position

func _sync_level_camera_from_character_camera() -> void:
	if detective == null or level_camera == null:
		return

	if detective.has_method("configure_external_camera"):
		detective.call("configure_external_camera", level_camera)

func _update_camera_mode() -> void:
	if detective == null or level_camera == null:
		return

	var using_character_camera: bool = detective.get("enable_character_camera")
	var use_level_camera := not using_character_camera

	level_camera.enabled = use_level_camera
	if use_level_camera:
		level_camera.global_position = detective.global_position
		level_camera.make_current()

	set_physics_process(use_level_camera)

func _on_area_camera_shift_1_body_entered(body: Node2D) -> void:
	if body != detective:
		return

	var velocity := (body as CharacterBody2D).velocity
	
	if velocity.y == 0.0:
		return
	
	var offset := -280.0

	if velocity.y >= 0.0:
		offset = 0

	var target_offset := Vector2(level_camera.offset.x, offset)
	_lerp_level_camera_offset(target_offset)

func _lerp_level_camera_offset(target_offset: Vector2) -> void:
	if camera_offset_tween != null and camera_offset_tween.is_valid():
		camera_offset_tween.kill()

	camera_offset_tween = create_tween()
	camera_offset_tween.tween_property(
		level_camera,
		"offset",
		target_offset,
		CAMERA_SHIFT_LERP_SECONDS
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
