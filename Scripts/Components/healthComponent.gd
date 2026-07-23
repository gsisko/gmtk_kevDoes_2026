extends Node
class_name HealthComponent

signal health_update(change:float, current:float)
signal gained_health(change:float, current:float)
signal lost_health(change:float, current:float)
signal health_depleted()

@export var debug: bool

@export var max_health: float
@export var curr_health: float:
	set(update):
		curr_health = clampf(update, 0, max_health)
		if update == curr_health: return
		
		if curr_health <= 0: health_depleted.emit()
		
		if debug: print("Health Updated | %s" %[curr_health])
		health_update.emit(curr_health-update, curr_health)

func lose_health(amount:float):
	curr_health = curr_health-amount
	lost_health.emit(amount, curr_health)
func gain_health(amount:float):
	curr_health = curr_health + amount
	gained_health.emit(amount, curr_health)
func reset_health(): curr_health = max_health
func die(): curr_health = 0
