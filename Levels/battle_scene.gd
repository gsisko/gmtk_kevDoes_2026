extends Node3D
class_name BattleScene

signal round_time_tick(tick:float)
signal round_start

enum BATTLE_STATE {Battle_Start, Pre_Round, Duel, Post_Round, Battle_End}
var state:BATTLE_STATE = BATTLE_STATE.Battle_Start :
	set(update):
		if update == state: return
		
		await _on_exit_state()
		state = update
		_on_enter_state()

@onready var players:Array[PlayerCharacter] = [$PlayerCharacter, $PlayerCharacter2]
@onready var camera:Camera3D = $Camera3D

@export var round_length_sec:float = 5
@onready var round_timer:Timer = $Timer

var battle_round:int = 1 : 
	set(update):
		battle_round = update
		print("NEW ROUND: %s" %[battle_round])
func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	GameManager.game_start.connect(start_battle)
	
	GameManager.players = players
	GameManager.hud.sync_players()
	
	camera.make_current()
	round_timer.timeout.connect(end_round)
	
	
	#enter initial state
	_on_enter_state()

func _process(_delta: float) -> void: 
	_process_state()

func get_camera()->Camera3D: return camera

func start_battle():
	state = BATTLE_STATE.Battle_Start
	
func end_battle():
	state = BATTLE_STATE.Battle_End
func begin_round(): 
	state = BATTLE_STATE.Duel
func end_round():
	state = BATTLE_STATE.Post_Round

#region BATTLE FSM
func _on_enter_state():
	if Engine.is_editor_hint():return
	print("ENTERING - %s" %[BATTLE_STATE.keys()[state]])
	match state:
		BATTLE_STATE.Battle_Start: 
			#ensure both players are reset
			for i in players: 
				i.reset()
			battle_round = 1
			
		BATTLE_STATE.Duel: 
			round_timer.start(round_length_sec)
			round_start.emit()
		BATTLE_STATE.Pre_Round:
			for i in players:
				i.set_state(PlayerCharacter.PLAYER_STATE.IDLE)
		BATTLE_STATE.Post_Round: 
			round_timer.stop()
			var amount_out_gate: bool = false
			
			for i in players:
				##SEARCH FOR WIN CONDITION
				# PLAYER DEATH
				if i.is_dead(): 
					end_battle()
					return
				# NO MORE AMMO
				if i.get_ammo_count() <= 0: 
					#Open gate if one player is out of ammo, End Battle if Both are out
					if !amount_out_gate: amount_out_gate = true 
					else: end_battle() 
	
func _process_state():
	match state:
		BATTLE_STATE.Battle_Start: 	if _any_player_input(): state = BATTLE_STATE.Pre_Round
		BATTLE_STATE.Pre_Round: 	if _any_player_input(): state = BATTLE_STATE.Duel
		BATTLE_STATE.Duel:
			if Input.is_action_just_pressed("P1_Attack"):
				players[0].attack()
				if state == BATTLE_STATE.Duel: ## Is dueling still (Win Condition not met)
					end_round()
			if Input.is_action_just_pressed("P2_Attack"):
				players[1].attack()
				if state == BATTLE_STATE.Duel: ## Is dueling still (Win Condition not met)
					end_round()
		BATTLE_STATE.Post_Round: if _any_player_input(): state = BATTLE_STATE.Pre_Round
		BATTLE_STATE.Battle_End: if _any_player_input(): start_battle()
func _on_exit_state():
	print("EXITING - %s" %[BATTLE_STATE.keys()[state]])
#endregion
func get_time_distance_percentage():
	if round_timer.is_stopped(): return 0
	var difference_sec: float = round_length_sec-round_timer.time_left
	return (1.0 - (difference_sec/round_length_sec))
	
func _any_player_input()->bool:
	return Input.is_action_just_pressed("P1_Attack") || Input.is_action_just_pressed("P2_Attack")
