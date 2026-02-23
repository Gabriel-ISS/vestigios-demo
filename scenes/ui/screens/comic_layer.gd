class_name ComicLayer extends CanvasLayer

var _pages: Array[ComicPage]

@onready var current_page_img: TextureRect = $CurrentPage
@onready var next_page_img: TextureRect = $NextPage

@onready var background_audio_mixer: AudioManager = $BackgroundAudioMixer
@onready var initial_sfx_mixer: AudioManager = $InitialSfxMixer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var next_or_close_btn: Button = $MarginContainer/NextOrClose

var current_page_index = 0

func _ready() -> void:
	visible = false


func open_comic(pages: Array[ComicPage]):
	_pages = pages
	visible = true
	current_page_index = 0
	
	if not pages.size():
		printerr('Se necesita al menos una página de comic')
		return
	
	var current_page = _pages[current_page_index]
	background_audio_mixer.play(current_page.background_sound)
	initial_sfx_mixer.play(current_page.initial_sound)
	
	current_page_img.texture = current_page.image
	animation_player.play("show_first")


func close_comic():
	animation_player.play("hide")
	background_audio_mixer.stop()
	initial_sfx_mixer.stop()


func switch_page(current_page: ComicPage, next_page: ComicPage):
	background_audio_mixer.play(next_page.background_sound)
	initial_sfx_mixer.play(next_page.initial_sound)
	
	# ! esto sigue siendo un cambio brusco
	current_page_img.texture = current_page.image
	next_page_img.texture = next_page.image
	
	animation_player.play("switch_page")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		'hide':
			visible = false
		'switch_page':
			# preparamos para el próximo cambio
			current_page_img.texture = next_page_img.texture
			current_page_img.self_modulate.a = 1
			next_page_img.self_modulate.a = 0
	
	next_or_close_btn.disabled = false


func _on_next_or_close_pressed() -> void:
	var last_index = _pages.size() - 1
	
	if current_page_index < last_index:
		var current_page = _pages[current_page_index]
		var next_page = _pages[current_page_index + 1]
		switch_page(current_page, next_page)
	else:
		close_comic()
	
	current_page_index += 1
	
	next_or_close_btn.disabled = true
	if current_page_index == last_index:
		next_or_close_btn.text = 'Close'
