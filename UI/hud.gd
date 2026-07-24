extends Control
class_name HUD


@onready var timer_label:Label = $MarginContainer/HBoxContainer/timer_txt

@onready var p1_hud: PlayerHUD = $MarginContainer/HBoxContainer/PlayerHUD
@onready var p2_hud: PlayerHUD = $MarginContainer/HBoxContainer/PlayerHUD2


func _ready() -> void:
	GameManager.hud = self
	
#var this is a bad method but just to make it work for now
func sync_players():
	p1_hud.sync_to_player(GameManager.players[0])
	p2_hud.sync_to_player(GameManager.players[1])

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if !GameManager.battle_instance: return
	
	timer_label.text = str(roundi(GameManager.battle_instance.round_timer.time_left))
