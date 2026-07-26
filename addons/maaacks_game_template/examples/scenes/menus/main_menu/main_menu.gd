extends MainMenu


@export_group("Background", "_bg")
@export var _bg_idle_texture:Texture
@export var _bg_play_texture:Texture
@export var _bg_anim_length:float
@onready var bg_node:TextureRect = %BackgroundTextureRect
@onready var _anim:AnimationPlayer = $AnimationPlayer

@export_group("SFX", "_sfx")
@export var _sfx_gunshot:AudioStream

func new_game() -> void:
	if bg_node: bg_node.texture = _bg_play_texture
	
	AudioManager.play_sfx(_sfx_gunshot)
	
	if _anim: 
		_anim.play("flash")
		await get_tree().create_timer(_anim.current_animation_length).timeout
		
	await get_tree().create_timer(_bg_anim_length).timeout
	
	if _anim: 
		_anim.play("black_fade")
		await get_tree().create_timer(_anim.current_animation_length).timeout
	
	super.new_game()

func _ready() -> void:
	super._ready()
	
	
	
	#Set BG
	if bg_node: bg_node.texture = _bg_idle_texture
