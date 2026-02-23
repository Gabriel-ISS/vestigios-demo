# Esta clase se encarga de gestionar el audio del juego para
# permitir transiciones suaves entre audios
class_name AudioManager extends Node

@onready var audio_player1: AudioStreamPlayer = $AudioStreamPlayer1
@onready var audio_player2: AudioStreamPlayer = $AudioStreamPlayer2

var is_fading = false
var tween: Tween

func _ready() -> void:
	audio_player2.volume_db = -80


func play(audio: AudioStream, duration: float = 1):
	if is_fading:
		printerr('Las colas aun no estan implementadas')
	
	if audio_player1.playing:
		audio_player2.stream = audio
		audio_player2.play()
		_crossfade(audio_player1, audio_player2, duration)
	elif audio_player2.playing:
		audio_player1.stream = audio
		audio_player1.play()
		_crossfade(audio_player2, audio_player1, duration)
	else:
		# en caso de que ninguno de los dos se este usando se usa el primero
		audio_player1.stream = audio
		audio_player1.play()


func stop(duration: float = 1):
	if is_fading:
		printerr('Las colas aun no estan implementadas')
	
	if audio_player1.playing:
		_fade_out(audio_player1, duration)
	elif audio_player2.playing:
		_fade_out(audio_player2, duration)


func _fade_out(stream_player: AudioStreamPlayer, duration: float):
	is_fading = true
	tween = create_tween()
	tween.parallel().tween_property(stream_player, "volume_db", -80, duration)
	tween.tween_callback(func(): _after_fade_shutdown(stream_player))


func _crossfade(fade_out: AudioStreamPlayer, fade_in: AudioStreamPlayer, duration: float) -> void:
	is_fading = true
	tween = create_tween()
	tween.parallel().tween_property(fade_out, "volume_db", -80, duration)
	tween.parallel().tween_property(fade_in, "volume_db", 0, duration)
	tween.tween_callback(func(): _after_fade_shutdown(fade_out))


func _after_fade_shutdown(stream_player: AudioStreamPlayer):
	is_fading = false
	stream_player.stop()
