extends Control
class_name PlayerHUD


@export var _ammo_tokens: Array[AmmoToken] = []


var _player: PlayerCharacter


@onready var _hp_bar:Health_Bar = $VBoxContainer/HealthBar

func sync_to_player(player: PlayerCharacter):
	_player = player
	
	_hp_bar.set_health(_player.health)
	_player.attacked.connect(_on_player_attacked)
	
	
func _on_player_attacked():
	if _player.get_ammo_count() >= _ammo_tokens.size(): return
	
	var missing_amount:int = _ammo_tokens.size()- _player.get_ammo_count()
	
	for i in range(missing_amount):
		if _ammo_tokens[i].visible: _ammo_tokens[i].is_active = false
		
