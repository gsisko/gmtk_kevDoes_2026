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

@export var data:Character_Data :
	set(update):
		data = update
		_on_data_update()

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
@onready var _p_hud: PlayerHUD = %PlayerHUD
@onready var _damage_counter:DamageCounter = $Dmg_Counter
@onready var _anim:AnimationPlayer = $AnimationPlayer

var init_transform:Transform2D

@onready var zoom_target : Marker2D = $zoom_target

func _ready() -> void:
	
	
	if Engine.is_editor_hint(): return
	if _p_hud: _p_hud.flip_hud(_sprite_show_back)
	
	
	GameManager.game_start.connect(reset)
	_p_hud.sync_to_player(self)
	health.lost_health.connect(_handle_health_loss)
	health.health_depleted.connect(_handle_death)
	if data: _on_data_update()

func set_data(character_data:Character_Data): data = character_data

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint(): return
	_process_state()

func attack():
	if curr_shots <= 0: return
	_state = PLAYER_STATE.ATTACK
	damage.deal_damage(target.health)
	curr_shots -= 1
	AudioManager.play_sfx(data.sfx_shoot)
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

func get_ammo_count()->int: 
	print("AMMO COUNT: %s" %[curr_shots])
	return curr_shots
func is_dead()->bool: return _state == PLAYER_STATE.DEAD

func _on_data_update():
	if !_sprite: return
	_sprite.texture = data.sprite_sheet
	_sprite.scale = data.sprite_scale

func _update_animation():
	if !_sprite: return
	var perspective_id:int = 1 if _sprite_show_back else 0
	_sprite.frame_coords = Vector2(perspective_id, _anim_row_anchor[_state])
	_sprite.flip_h = _sprite_flipped
	
	if _anim: _anim.play("sprite_bounce")
func _handle_health_loss(change:float, _current:float):
	#PLAY ANIMATION DAMAGE
	var amount:int = abs(int(change))
	_damage_counter.text = str(amount)
	_damage_counter.launch(amount)
	
	if _current > 0: 
		AudioManager.play_sfx(data.sfx_hit)
		_state = PLAYER_STATE.HIT

func _handle_death():
	AudioManager.play_sfx(data.sfx_hit)
	_state = PLAYER_STATE.DEAD
	dead.emit()
