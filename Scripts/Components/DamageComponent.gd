extends Node
class_name DamageComponent

@export var _max_damage:float = 100
@export var _damage_curve: Curve

func deal_damage(health:HealthComponent):
	health.lose_health(_calculate_damage())

func _calculate_damage()->float:
	return _max_damage
