extends Timer

@export var final: CanvasLayer

@export var light_node_path: NodePath = "../"

@export var min_scale: float = 0.0
@export var total_duration: float = 10.0

# === CURVA ===
@export var use_curve: bool = false
@export var curve: Curve

@export var curve_mode: int = 0
# 0 = Lineal
# 1 = Ease Out
# 2 = Ease InOut
# 3 = Caída dramática

# === FLICKER ===
@export var flicker_enabled := true
@export var flicker_speed := 20.0
@export var flicker_intensity := 0.05

# Interno
var elapsed_time := 0.0
var initial_scale := 1.0
var finished := false

@onready var light: PointLight2D = null


func _ready():

	light = get_node(light_node_path) as PointLight2D
	if not light:
		push_error("No se encontró la luz")
		return

	initial_scale = light.texture_scale

	wait_time = 0.05
	start()
	timeout.connect(_on_timeout)


func _on_timeout():

	if finished:
		return

	elapsed_time += wait_time

	var t = clamp(elapsed_time / total_duration, 0.0, 1.0)

	# === Si terminó el tiempo ===
	if t >= 1.0:
		_finish_light()
		return

	# === Aplicar curva ===
	t = _apply_curve(t)

	var base_scale = lerp(initial_scale, min_scale, t)

	# === Flicker solo mientras esté encendida ===
	if flicker_enabled:
		base_scale += sin(Time.get_ticks_msec() * 0.001 * flicker_speed) * flicker_intensity

	light.texture_scale = max(base_scale, 0.0)


func _finish_light():
	final.visible = true

	finished = true
	stop()

	light.texture_scale = 0.0
	light.visible = false
	# También podrías usar:
	# light.enabled = false


func _apply_curve(t: float) -> float:

	if use_curve and curve:
		return curve.sample(t)

	match curve_mode:
		0:
			return t
		1:
			return pow(t, 2)
		2:
			return t * t * (3 - 2 * t)
		3:
			return pow(t, 3)

	return t


	
