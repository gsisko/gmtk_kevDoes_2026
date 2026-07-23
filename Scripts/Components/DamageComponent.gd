extends Node
class_name DamageComponent


@export var debug:bool

@export var _max_damage:float = 100
@export var _damage_curve: Curve

func deal_damage(health:HealthComponent):
	var damage:float = _calculate_damage()
	if debug: print("%s DAMAGE DEALTH TO %s" %[damage, health.get_parent().name])
	health.lose_health(damage)

func _calculate_damage()->float:
	var sample_percent:float = GameManager.get_time_distance_percentage(Time.get_ticks_msec())
	if debug: print("Damage Sampling with Percentage [%s]" %[sample_percent])
	return _max_damage * (_damage_curve.sample(sample_percent))
