extends Node3D
class_name PlayerCharacter



@export var player_id:int = -1
@export var target:PlayerCharacter

@onready var health:HealthComponent = $HealthComponent
@onready var damage:DamageComponent = $DamageComponent
@export var max_shots:int = 6
var curr_shots

func _ready() -> void:
	GameManager.game_start.connect(reset)

func attack():
	if curr_shots <= 0: return
	damage.deal_damage(target.health)
	curr_shots -= 1

func reset():
	curr_shots = max_shots
	health.reset_health()
