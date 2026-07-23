extends Control
class_name HUD


@onready var timer_label:Label = $MarginContainer/HBoxContainer/timer_txt

@onready var p1_bar: Health_Bar = $MarginContainer/HBoxContainer/HealthBar
@onready var p2_bar: Health_Bar = $MarginContainer/HBoxContainer/HealthBar2

func _process(_delta: float) -> void:
	if !GameManager.battle_instance: return
	
	p1_bar.set_health(GameManager.players[0].health)
	p2_bar.set_health(GameManager.players[1].health)
	
	timer_label.text = str(roundi(GameManager.battle_instance.round_timer.time_left))
	
	
