extends Node


enum BUS_TAG {BUS_BGM, BUS_SFX, BUS_UI}

var _bmg_player:	AudioStreamPlayer
var _sfx_player: 	AudioStreamPlayer
var _ui_player :	AudioStreamPlayer

var root:Node

func _ready() -> void:
	if !root: 
		root = Node.new()
		
	

func switch_bgm(new_bgm:AudioStream): 
	if _bmg_player:
		_bmg_player.stream = new_bgm
		_bmg_player.play()
func play_sfx(sound:AudioStream): pass
	
