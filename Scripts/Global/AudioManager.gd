extends Node


enum BUS_TAG {BUS_BGM, BUS_SFX, BUS_UI}

var _bgm_player:	AudioStreamPlayer
var _sfx_player: 	AudioStreamPlayer
var _ui_player :	AudioStreamPlayer

var root:Node

func _ready() -> void:
	if !root: 
		root = Node.new()
		add_child(root)
		
	

func switch_bgm(new_bgm:AudioStream): 
	if _bgm_player:
		_bgm_player.stream = new_bgm
		_bgm_player.play()
func play_sfx(sound:AudioStream): 
	if _sfx_player:
		_sfx_player.stream = sound
		_sfx_player.play()
	
	
