extends Node2D
class_name BattleScene

signal round_start

enum BATTLE_STATE {Battle_Start, Pre_Round, Duel, Post_Round, Battle_End}
var state:BATTLE_STATE = BATTLE_STATE.Battle_Start :
	set(update):
		if update == state: return
		
		await _on_exit_state()
		state = update
		_on_enter_state()

@onready var players:Array[PlayerCharacter] = [$PlayerCharacter, $PlayerCharacter2]
@onready var camera:Camera2D = $Camera2D

@export var round_length_sec:float = 5
@onready var round_timer:Timer = $Timer

var battle_round:int = 1 : 
	set(update):
		battle_round = update
		print("NEW ROUND: %s" %[battle_round])
func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	GameManager.game_start.connect(start_battle)
	GameManager.ui.show_hud()
	
	GameManager.players = players
	
	camera.make_current()
	round_timer.timeout.connect(end_round)
	for i in players:
		i.attacked.connect(end_round)
		i.dead.connect(end_battle)
	
	#enter initial state
	_on_enter_state()
func _process(_delta: float) -> void: 
	_process_state()

func get_camera()->Camera2D: return camera

func start_battle(): state = BATTLE_STATE.Battle_Start
func end_battle(): state = BATTLE_STATE.Battle_End
func begin_round(): state = BATTLE_STATE.Duel
func end_round(): state = BATTLE_STATE.Post_Round

func get_time_distance_percentage():
	if round_timer.is_stopped(): return 0
	var difference_sec: float = round_length_sec-round_timer.time_left
	return (difference_sec/round_length_sec)
func _any_player_input()->bool:
	return Input.is_action_just_pressed("P1_Attack") || Input.is_action_just_pressed("P2_Attack")

##Gives order of players based on if they have more health or not
func _players_by_health() -> Array[PlayerCharacter]:
	var result:Array[PlayerCharacter]
	
	#HARD CODED BUT WORKS
	if players[0].health.curr_health >= players[1].health.curr_health: 
		result = [ players[0], players[1]]
	else: result = [ players[1], players[0]]
	
	return result
func _get_last_standing()->PlayerCharacter:
	##Assume that other player is alive if player is dead
	var result: PlayerCharacter
	for i in players:
		if i.is_dead(): result = i.target
	return result
func _get_total_ammo() -> int:
	var count:int = 0
	for i in players: count += i.get_ammo_count()
	return count
func _win_condition_met()->bool:
	return _get_last_standing() != null || _get_total_ammo() <= 0


#region BATTLE FSM
func _on_enter_state():
	if Engine.is_editor_hint():return
	print("ENTERING - %s" %[BATTLE_STATE.keys()[state]])
	match state:
		BATTLE_STATE.Battle_Start: 
			GameManager.ui.show_hud()
			#ensure both players are reset
			for i in players: 
				i.reset()
			battle_round = 1
			state = BATTLE_STATE.Pre_Round
		BATTLE_STATE.Pre_Round:
			for i in players:
				i.set_state(PlayerCharacter.PLAYER_STATE.IDLE)
		BATTLE_STATE.Duel: 
			round_timer.start(round_length_sec)
			round_start.emit()
		BATTLE_STATE.Post_Round: 
			round_timer.stop()
			if _win_condition_met(): end_battle()
		BATTLE_STATE.Battle_End: 
			if !round_timer.is_stopped(): round_timer.stop()
			GameManager.ui.close_hud()
			var victory:Control = UI.open_overlay(UI.OVERLAY.Victory)
			if victory:
				if victory is VictoryMenu: 
					victory.set_winner(_players_by_health()[0].data)
					victory.set_loser(_players_by_health()[1].data)
			# OPEN RESULT OVERLAY
			queue_free()
func _process_state():
	match state:
		BATTLE_STATE.Pre_Round: 	if _any_player_input(): state = BATTLE_STATE.Duel
		BATTLE_STATE.Duel:
			if Input.is_action_just_pressed("P1_Attack"):
				players[0].attack()
				return
			if Input.is_action_just_pressed("P2_Attack"):
				players[1].attack()
				return
		BATTLE_STATE.Post_Round: 	if _any_player_input(): state = BATTLE_STATE.Pre_Round
func _on_exit_state():
	print("EXITING - %s" %[BATTLE_STATE.keys()[state]])
#endregion
