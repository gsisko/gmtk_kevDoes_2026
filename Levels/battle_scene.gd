extends Node3D
class_name BattleScene

@onready var camera:Camera3D = $Camera3D
var battle_round:int = 1

func get_camera()->Camera3D: return camera
