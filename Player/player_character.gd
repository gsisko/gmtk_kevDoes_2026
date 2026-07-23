extends Node3D
class_name PlayerCharacter

signal attacked

@export var target:PlayerCharacter

@onready var health:HealthComponent = $HealthComponent
@onready var damage:DamageComponent = $DamageComponent
@export var max_shots:int = 6
var curr_shots:int = 6

func _ready() -> void:
	GameManager.game_start.connect(reset)
	health.health_depleted.connect(_handle_death)

func attack():
	if curr_shots <= 0: return
	damage.deal_damage(target.health)
	curr_shots -= 1
	attacked.emit()
func _handle_death():
	hide()
func reset():
	if !visible: show()
	curr_shots = max_shots
	health.reset_health()
