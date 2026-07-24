@tool
extends Node2D
class_name PlayerCharacter

signal attacked
signal bullet_amount_update()

enum PLAYER_STATE {IDLE, HIT, ATTACK, DEAD}
@export var _state:PLAYER_STATE = PLAYER_STATE.IDLE :
	set(update):
		if update == _state: return
		_on_state_exit()
		_state = update
		_on_state_enter()
## ANIMATION ANCHORS PER STATE
var _anim_row_anchor:Dictionary[PLAYER_STATE, int] = {
	PLAYER_STATE.IDLE:	 0, 
	PLAYER_STATE.ATTACK: 2, 
	PLAYER_STATE.HIT:	 3,
	PLAYER_STATE.DEAD:	 4
}

@export var target:PlayerCharacter
@export var max_shots:int = 6

var curr_shots:int = 6 : 
	set(update):
		curr_shots = clampi(update, 0, max_shots)
		bullet_amount_update.emit()

@onready var _sprite:Sprite2D = $Sprite2D
@export_group("Sprite Settings","_sprite")
@export var _sprite_show_back:bool = false :
	set(update):
		_sprite_show_back = update
		_update_animation()
@export var _sprite_flipped:bool = false :
	set(update):
		_sprite_flipped = update
		_update_animation()

@onready var health:HealthComponent = $HealthComponent
@onready var damage:DamageComponent = $DamageComponent

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	GameManager.game_start.connect(reset)
	health.health_depleted.connect(_handle_death)

func _on_game_start():
	if GameManager.battle_instance:
		GameManager.battle_instance.round_start.connect(_on_round_start)
func _process(_delta: float) -> void:
	if !Engine.is_editor_hint(): return
	_process_state()

func attack():
	_state = PLAYER_STATE.ATTACK
	if curr_shots <= 0: return
	damage.deal_damage(target.health)
	curr_shots -= 1
	attacked.emit()
func reset():
	curr_shots = max_shots
	health.reset_health()
	_state = PLAYER_STATE.IDLE
	redraw_sprite()
	
func redraw_sprite(): _update_animation()
func set_state(state:PLAYER_STATE): 
	_state = state

#region Player FSM
func get_state()->PLAYER_STATE: return _state
func _on_state_enter(): 
	_update_animation()
func _process_state(): pass
func _on_state_exit(): pass
#endregion

func get_ammo_count()->int: return curr_shots
func is_dead()->bool: return _state == PLAYER_STATE.DEAD

func _update_animation():
	if !_sprite: return
	var perspective_id:int = 1 if _sprite_show_back else 0
	_sprite.frame_coords = Vector2(perspective_id, _anim_row_anchor[_state])
	_sprite.flip_h = _sprite_flipped
func _handle_death():
	_state = PLAYER_STATE.DEAD
func _on_round_start(): _state = PLAYER_STATE.IDLE
