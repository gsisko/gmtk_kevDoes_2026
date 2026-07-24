@tool
extends Node2D
class_name PlayerCharacter

signal attacked
signal bullet_amount_update
signal dead

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
	PLAYER_STATE.ATTACK: 1, 
	PLAYER_STATE.HIT:	 2,
	PLAYER_STATE.DEAD:	 3
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
@onready var _p_hud: PlayerHUD = $PlayerHUD
@onready var _damage_counter:Label = $Dmg_Counter
@onready var _anim:AnimationPlayer = $AnimationPlayer

var init_transform:Transform2D

func _ready() -> void:
	##A bit hard coded but it makes it work... Hud can switch sides based on character perspective
	_p_hud.flip_hud(_sprite_show_back)
	
	if Engine.is_editor_hint(): return
	
	
	GameManager.game_start.connect(reset)
	_p_hud.sync_to_player(self)
	health.health_depleted.connect(_handle_death)
	health.lost_health.connect(_handle_health_lose)

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
func _handle_health_lose(_change:float, _current:float):
	#PLAY ANIMATION DAMAGE
	_damage_counter.text = str(abs(int(_change)))
	_anim.play("Damage_Counter_Tick")
	
	_state = PLAYER_STATE.HIT
	
func _handle_death():
	_state = PLAYER_STATE.DEAD
	dead.emit()
func _on_round_start(): _state = PLAYER_STATE.IDLE
