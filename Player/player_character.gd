extends Node3D
class_name PlayerCharacter

@export var player_id:int = -1
@onready var health:HealthComponent = $HealthComponent
@onready var damage:DamageComponent = $DamageComponent

func _ready() -> void:
	
