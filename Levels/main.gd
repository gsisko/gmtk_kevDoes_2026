extends CanvasLayer

@onready var battle_scene:PackedScene = preload("uid://clyy8ub0nlhdm")
@onready var level_root:Node3D = $Level_Root




func _ready() -> void:
	GameManager.game_start.connect(on_game_start)
	GameManager.start_game()
	
func on_game_start():
	if !GameManager.battle_instance:
		GameManager.battle_instance = battle_scene.instantiate()
		level_root.add_child(GameManager.battle_instance)
