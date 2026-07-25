extends Control
class_name PlayerHUD

@export var _ammo_tokens: Array[AmmoToken] = []

var _player: PlayerCharacter

@onready var _hp_bar:Health_Bar = $HBoxContainer/VBoxContainer/HealthBar
@export  var flipped:bool = false

func flip_hud(flip:bool): 
	if flip:
		scale.x = abs(scale.x)
		position.x = 0.0
	else:
		scale.x = abs(scale.x)*-1
		position.x = size.x/2.5
	
func sync_to_player(player: PlayerCharacter):
	_player = player
	_hp_bar.set_health(_player.health)
	_player.bullet_amount_update.connect(_on_player_bullet_update)
	
func _on_player_bullet_update():
	if !_player: 
		push_error("Null Player")
		return
		
	for i in range(_ammo_tokens.size()):
		if _ammo_tokens[i]: _ammo_tokens[i].is_active = (i < _player.get_ammo_count())
		
