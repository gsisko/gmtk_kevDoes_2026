extends TextureProgressBar
class_name Health_Bar

var _health : HealthComponent :
	set(update):
		if update != _health: 
			if _health: _health.health_update.disconnect(_update_display)
			_health = update
			if !_health: return
			_health.health_update.connect(_update_display)

func set_health(health:HealthComponent): _health = health

func _update_display(change:float, current:float):
	value = current/_health.max_health
	
