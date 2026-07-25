extends CanvasLayer

@onready var battle_scene:PackedScene = preload("uid://clyy8ub0nlhdm")
@onready var level_root:Node2D = $Level_Root
@onready var _ui_instance: UI = $UI


@export var _p1_data:Character_Data
@export var _p2_data:Character_Data

func _ready() -> void:
	GameManager.main_root = self
	GameManager.ui = _ui_instance
	GameManager.game_start.connect(on_game_start)
	GameManager.start_game()
	
func on_game_start():
	if !GameManager.battle_instance:
		print("NEW BATTLE")
		GameManager.battle_instance = battle_scene.instantiate()
		level_root.add_child(GameManager.battle_instance)
