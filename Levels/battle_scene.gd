extends Node3D
class_name BattleScene

enum BATTLE_STATE

@onready var camera:Camera3D = $Camera3D
var round

func get_camera()->Camera3D: return camera
