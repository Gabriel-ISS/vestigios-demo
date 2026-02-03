extends PointLight2D

@export_category('Dependencies')
@export var dead_screen: CanvasLayer

@export_category('General')
@export var min_scale: float = 0.0
@export var total_duration: float = 60.0

@export_category('Curve')
@export var use_curve: bool = false
@export var curve: Curve
@export_enum("Linear", "Ease Out", "Ease InOut", "Caída Dramática") var curve_mode: int = 1

@export_category('Flicker')
@export var flicker_enabled := true
@export var flicker_speed := 20.0
@export var flicker_intensity := 0.02

var elapsed_time := 0.0
var finished := false
var initial_scale := 0.0  # Guardamos el escala inicial para lerp correcto

func _ready():
	initial_scale = texture_scale  # Capturamos el valor inicial del editor o script

func _process(delta: float) -> void:
	if finished:
		return

	elapsed_time += delta
	var t = clamp(elapsed_time / total_duration, 0.0, 1.0)

	# Si llegó al final
	if t >= 1.0:
		_finish_light()
		return

	# Aplicar curva de atenuación
	t = _apply_curve(t)

	# Interpolación CORRECTA: desde inicial hasta min_scale, basada en t (progreso curvo)
	var target_scale = lerp(initial_scale, min_scale, t)

	# === Flicker (solo mientras esté viva) ===
	if flicker_enabled:
		target_scale += sin(Time.get_ticks_msec() * 0.001 * flicker_speed) * flicker_intensity

	texture_scale = max(target_scale, 0.0)

func _finish_light():
	dead_screen.visible = true
	finished = true
	texture_scale = 0.0
	visible = false
	set_process(false)  # Detenemos _process para ahorrar rendimiento

func _apply_curve(t: float) -> float:
	if use_curve and curve:
		return curve.sample(t)
	
	match curve_mode:
		0: return t  # Linear
		1: return 1.0 - pow(1.0 - t, 2.0)  # Ease Out: caída rápida al inicio, lenta al final
		2: return t * t * (3.0 - 2.0 * t)  # Smoothstep (Ease InOut): suave en ambos extremos
		3: return pow(t, 5.0)  # Caída Dramática: estable al inicio, caída abrupta al final (ajustado para más drama)
		_: return t
