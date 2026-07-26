extends Node

signal game_start
signal player_died(player:PlayerCharacter)

enum GAMEMODE {MENU, BATTLE, VICTORY}
var mode:GAMEMODE = GAMEMODE.MENU

var main_root: MainLevel
var main_menu_scene: PackedScene = preload("uid://byvydukidk6i2")

var BGM:AudioStreamPlayer
var global_SFX

var battle_instance:BattleScene
var ui:UI

var players
var player_data : Array[Character_Data]

#region DEBUG
func _on_health_update(_change:float, current:float, player:PlayerCharacter): 
	print("HEALTH UPDATE [%s]: %s" %[player.name, current])
#endregion

#RESET TO MAIN MENU
func main_menu():
	var menu: MainMenu = main_menu_scene.instantiate()
	get_tree().root.add_child(menu)
	if main_root: main_root.queue_free()
	
func start_game(): game_start.emit()

func start_battle(data_1:Character_Data, data_2:Character_Data):
	main_root._start_battle()
	if battle_instance:
		battle_instance.set_data(data_1,data_2)

func quit_game(): get_tree().quit()

func get_battle_scene() -> BattleScene: return battle_instance
