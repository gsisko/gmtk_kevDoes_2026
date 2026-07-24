extends Control
class_name Health_Bar

@onready var bar:TextureProgressBar = $TextureProgressBar

var _health : HealthComponent :
	set(update):
		if update != _health: 
			if _health: _health.health_update.disconnect(_update_display)
			_health = update
			if !_health: return
			_health.health_update.connect(_update_display)

func set_health(health:HealthComponent): 
	_health = health
	_update_display(0, _health.curr_health)

func _update_display(change:float, current:float):
	if !_health:return
	bar.value = (_health.curr_health/_health.max_health) * bar.max_value
