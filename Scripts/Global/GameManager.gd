extends Node

signal game_start
signal player_died(player:PlayerCharacter)

enum GAMEMODE {MENU, BATTLE}
var battle_start_time: float
var battle_goal_time: float

var players : Array[PlayerCharacter]:
	set(update):
		_remove_player_connections()
		players = update
		_add_player_connections()

func _add_player_connections(): # Hook up UI ELEMENTS TO PLAYER
	if players.is_empty(): return
	for i in players:
		if !i.health.health_update.is_connected(_on_health_update.bind(i)):
			i.health.health_update.connect(_on_health_update.bind(i))
		if !i.health.health_depleted.is_connected(emit_signal.bind("player_died", i)):
			i.health.health_depleted.connect(emit_signal.bind("player_died", i))
func _remove_player_connections():
	if players.is_empty(): return
	for i in players:
		if i.health.health_update.is_connected(_on_health_update.bind(i)):
			i.health.health_update.disconnect(_on_health_update.bind(i))
		if i.health.health_depleted.is_connected(emit_signal.bind("player_died", i)):
			i.health.health_depleted.disconnect(emit_signal.bind("player_died", i))

#region DEBUG
func _on_health_update(_change:float, current:float, player:PlayerCharacter): 
	print("HEALTH UPDATE [%s]: %s" %[player.name, current])
#endregion


func start_game(): game_start.emit()
func start_round_timer(length_seconds:float):
	battle_start_time = Time.get_ticks_msec()
	battle_goal_time = battle_start_time +  (length_seconds * 1000) # Make length into msecs

func get_time_distance_percentage(time_msec:float) -> float:
	#Get the Absolute difference
	var difference:float = absf(battle_goal_time-time_msec) 
	
	return clampf(1.0 - (difference/battle_goal_time), 0 ,1.0)
	
