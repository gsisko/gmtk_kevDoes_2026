extends CanvasLayer
class_name MainLevel


@onready var battle_scene:PackedScene = preload("uid://clyy8ub0nlhdm")
@onready var character_select_scene: PackedScene = preload("uid://br16uk57e2jrn")

@onready var level_root:Node2D = $Level_Root
@onready var _ui_instance: UI = $UI


func _ready() -> void:
	GameManager.main_root = self
	GameManager.ui = _ui_instance
	GameManager.game_start.connect(on_game_start)
	GameManager.start_game()
	
func on_game_start():
	start_battle()
	#start_character_select()

func start_battle():
	if !GameManager.battle_instance:
		print("NEW BATTLE")
		GameManager.battle_instance = battle_scene.instantiate()
		level_root.add_child(GameManager.battle_instance)
func start_character_select():
	if !UI.instance:return
	UI.open_overlay(UI.OVERLAY.Character_Select)
		
