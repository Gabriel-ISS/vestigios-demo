@tool
extends Node2D

# Este escript facilita la gestion y variacion de items como arboles y arbustos
# Soporta animaciones donde cada fila es una variante y cada columna un frame

@export_category('Texture')
@export var atlas_texture: Texture2D : set = _set_atlas_texture
@export var rows: int = 1 : set = _set_rows
@export var columns: int = 1 : set = _set_columns

@export_category('Animation')
@export var animation_fps: float = 5.0 : set = _set_animation_fps

@export_category('Variant selection')
@export var selected_variant: int = 0 : set = _set_selected_variant
@export var mirror_sprite: bool = false : set = _set_mirror_sprite

@export_category('Randomize')   # solo afecta en runtime
@export var pick_random: bool = false
@export var random_mirroring: bool = false

@export_category('Collision')
@export var disable_collision = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	collision_shape.disabled = disable_collision
	_update_sprite_frames()
	_play_variant()

# ── Setters ────────────────────────────────────────────────────────────────

func _set_atlas_texture(value: Texture2D) -> void:
	atlas_texture = value
	_update_sprite_frames()
	_play_variant()


func _set_rows(value: int) -> void:
	rows = max(1, value)
	_update_sprite_frames()
	_play_variant()


func _set_columns(value: int) -> void:
	columns = max(1, value)
	_update_sprite_frames()
	_play_variant()


func _set_animation_fps(value: float) -> void:
	animation_fps = max(0.1, value)
	_update_sprite_frames()           # porque la velocidad está en SpriteFrames
	_play_variant()


func _set_selected_variant(value: int) -> void:
	selected_variant = clampi(value, 0, rows - 1)
	if Engine.is_editor_hint():
		_play_variant()

func _set_mirror_sprite(value: bool) -> void:
	mirror_sprite = value
	animated_sprite.scale.x = -1 if value else 1

# ── Lógica principal ───────────────────────────────────────────────────────

func _update_sprite_frames() -> void:
	if not animated_sprite or not atlas_texture:
		return

	# calculamos el ancho y alto aproximado de cada frame
	var atlas_size: Vector2i = atlas_texture.get_size()
	@warning_ignore("integer_division")
	var fw := atlas_size.x / columns
	@warning_ignore("integer_division")
	var fh := atlas_size.y / rows

	# Nos aseguramos de que no sobren pixeles
	# Solo para que quede bien pixel perfect
	# Lo puedes coemntar si te molesta
	if atlas_size.x % columns != 0 or atlas_size.y % rows != 0:
		push_error("Atlas no divisible → rows=%d cols=%d" % [rows, columns])
		animated_sprite.sprite_frames = null
		return

	# Generamos los frames para cada animacion
	var frames := SpriteFrames.new()
	for r in rows:
		var anim_name := "variant_%d" % r
		frames.add_animation(anim_name)
		
		# creamos y asignamos un AtlasTexture por cada frame
		for c in columns:
			var frame_region := Rect2i(c * fw, r * fh, fw, fh)
			var at := AtlasTexture.new()
			at.atlas = atlas_texture
			at.region = frame_region
			frames.add_frame(anim_name, at)
		
		# fianlmente establecemos loop y velocidad de esta variante
		frames.set_animation_speed(anim_name, animation_fps)
		frames.set_animation_loop(anim_name, true)

	# Asignamos los fames al AnimatedSprite2D
	animated_sprite.sprite_frames = frames


func _play_variant() -> void:
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	# escojemos la variante
	var variant: int

	# nos aseguramos de que solo se use random en runtime
	if not Engine.is_editor_hint():
		if pick_random:
			variant = randi_range(0, rows - 1)
		if random_mirroring:
			# establece en 1 o -1 de forma aleatoria
			animated_sprite.scale.x = randi() % 2 * 2 - 1

	# deducimos nombre de animación y la ejecutam
	var anim_name := "variant_%d" % variant
	animated_sprite.play(anim_name)
