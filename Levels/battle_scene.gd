extends Node3D
class_name BattleScene

enum BATTLE_STATE {Battle_Start, Pre_Round, Duel, Post_Round, Battle_End}
var state:BATTLE_STATE = BATTLE_STATE.Battle_Start :
	set(update):
		if update == state: return
		
		await _on_exit_state()
		state = update
		_on_enter_state()

@onready var players:Array[PlayerCharacter] = [$PlayerCharacter, $PlayerCharacter2]
@onready var camera:Camera3D = $Camera3D

@export var round_time_sec:float = 5
var battle_round:int = 1 : 
	set(update):
		battle_round = update
		print("NEW ROUND: %s" %[battle_round])
func _ready() -> void:
	if Engine.is_editor_hint(): return
	GameManager.players = players
	GameManager.game_start.connect(battle_start)
	for i in players:
		i.health.health_depleted.connect(_on_death.bind(i))

func _process(_delta: float) -> void: _process_state()

func get_camera()->Camera3D: return camera

func battle_start():
	#ensure both players are reset
	for i in players: 
		i.reset()
	battle_round = 1
	state = BATTLE_STATE.Battle_Start
func end_battle():
	state = BATTLE_STATE.Battle_End
func begin_round():
	battle_round += 1
	state = BATTLE_STATE.Duel
func end_round():
	state = BATTLE_STATE.Post_Round
func _on_death(player:PlayerCharacter):
	print("R.I.P. %s" %[player.name])
	end_battle()
#region BATTLE FSM
func _on_enter_state():
	print("ENTERING - %s" %[BATTLE_STATE.keys()[state]])
	match state:
		BATTLE_STATE.Duel:
			GameManager.start_round_timer(round_time_sec)
			print ("ROUND %s | Round Length: %s | Goal msec: %s |" %[battle_round, round_time_sec, GameManager.battle_goal_time])
func _process_state():
	match state:
		BATTLE_STATE.Battle_Start: _await_start_confirmation()
		BATTLE_STATE.Post_Round: _await_start_confirmation()
		BATTLE_STATE.Duel:
			if _is_times_up(): end_round()
			
			if Input.is_action_just_pressed("P1_Attack"):
				players[0].attack()
				if state == BATTLE_STATE.Duel: ## Is dueling still (Win Condition not met)
					end_round()
			if Input.is_action_just_pressed("P2_Attack"):
				players[1].attack()
				if state == BATTLE_STATE.Duel: ## Is dueling still (Win Condition not met)
					end_round()
		
		BATTLE_STATE.Battle_End:
			if Input.is_action_just_pressed("P1_Attack") || Input.is_action_just_pressed("P2_Attack"):
				battle_start()
func _on_exit_state():
	print("EXITING - %s" %[BATTLE_STATE.keys()[state]])
#endregion
func _is_times_up()->bool:
	return Time.get_ticks_msec() >= GameManager.battle_goal_time

func _await_start_confirmation():
	if Input.is_action_just_pressed("P1_Attack") || Input.is_action_just_pressed("P2_Attack"):
		begin_round()
