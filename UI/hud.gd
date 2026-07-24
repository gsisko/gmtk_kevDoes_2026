extends Control
class_name HUD


@onready var timer_label:Label = %timer_txt

func _ready() -> void:
	GameManager.hud = self
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if !GameManager.battle_instance: return
	
	timer_label.text = str(roundi(GameManager.battle_instance.round_timer.time_left))
