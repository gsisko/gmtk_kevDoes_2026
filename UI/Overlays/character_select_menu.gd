extends Control
class_name CharacterSelectMenu

@export var characters:Array[Character_Data] = []

@onready var _character_btn_scene: PackedScene = preload("uid://bupsvc1d1oexg")
@onready var _roster_root: Control = %roster_root

#region Character Elements
@onready var _portrait:TextureRect = %Portrait
@onready var _char_name:Label = %char_name
@onready var _char_desc:Label = %char_desc

@export var p1_data:Character_Data
@export var p2_data:Character_Data

@onready var _p1_profile:CharacterProfile = %CharacterProfile
@onready var _p2_profile:CharacterProfile = %CharacterProfile2

func _ready() -> void:
	_draw_roster()

func _update_player_info():
	if p1_data: _p1_profile.set_data(p1_data)
	if p2_data: _p2_profile.set_data(p2_data)

func _update_poster(data:Character_Data):
	var _texture: Texture = null
	var _name = ""
	var _desc = ""
	
	if data:
		_texture = data.portrait
		_name = data.name
		_desc = data.desc

	if _portrait: _portrait.texture = _texture
	if _char_name: _char_name.text = _name
	if _char_desc: _char_desc.text = _desc

func _draw_roster():
	await _clear_roster()
	for i in characters: _make_roster_selection(i)
func _make_roster_selection(data:Character_Data):
	var character_btn: Character_Button = _character_btn_scene.instantiate()
	_roster_root.add_child(character_btn)
	character_btn.set_poster_data(data)
	
	character_btn.mouse_hover.connect(_update_poster)
	character_btn.mouse_exited.connect(_update_poster.bind(null))
	character_btn.pressed.connect(_on_roster_item_pressed.bind(character_btn.data))
	
func _clear_roster():
	if _roster_root.get_children().is_empty(): return
	for i in _roster_root.get_children(): i.queue_free()

## TRACKS NEXT PLAYER TO SELECT BY P1 or P2 or 0 as None [Both Selected]
func _next_selecting_player_id()->int:
	var id: int = 0
	if !p1_data: id = 1
	elif !p2_data: id = 2
	return id

func _on_roster_item_pressed(roster_item_data:Character_Data):
	if !p1_data: p1_data = roster_item_data
	elif !p2_data: p2_data =  roster_item_data
	
	_update_player()

func _update_player():
	%player_hint_id.text = "[P%s]" %[_next_selecting_player_id()]
	if _next_selecting_player_id() == 0: 
		if %HBoxContainer.visible: %HBoxContainer.hide()
	elif !%HBoxContainer.visible: %HBoxContainer.show()
	_update_player_info()
func _on_menu_button_pressed() -> void:
	if !p1_data && !p2_data: 
		GameManager.main_menu()
		return
	elif p2_data: p2_data = null
	elif p1_data: p1_data = null
	
	_update_player()

func _on_start_button_pressed() -> void:
	if p1_data && p2_data: GameManager.start_battle(p1_data,p2_data)
	
	
