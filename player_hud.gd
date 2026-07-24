extends Control
class_name PlayerHUD


@export var _ammo_tokens: Array[AmmoToken] = []


var _player: PlayerCharacter


@onready var _hp_bar:Health_Bar = $VBoxContainer/HealthBar

func sync_to_player(player: PlayerCharacter):
	_player = player
	_hp_bar.set_health(_player.health)
	_player.bullet_amount_update.connect(_on_player_bullet_update)

func _on_player_bullet_update():
	if _player.get_ammo_count() > _ammo_tokens.size(): return
	
	var missing_amount:int = _ammo_tokens.size() - _player.get_ammo_count()
	print("UPDATE P_HUD BULLET COUNTER: \n| player has (%s), missing (%s)" %[_player.get_ammo_count(), missing_amount])
	for i in range(_player.get_ammo_count()): 
		if !_ammo_tokens[i].is_active && i >= missing_amount: _ammo_tokens[i].is_active = true
		if _ammo_tokens[i].is_active && i < missing_amount: _ammo_tokens[i].is_active = false
