extends Control
class_name CharacterSelectMenu

@export var characters:Array[Character_Data] = []

@onready var _character_btn_scene: PackedScene = preload("uid://bupsvc1d1oexg")
@onready var _roster_root: Control = $HBoxContainer/roster_root

#region Character Elements
@onready var _portrait:TextureRect = null
@onready var _char_name:Label = %char_name
@onready var _char_desc:Label = %char_desc

@export var p1_data:Character_Data
@export var p2_data:Character_Data

func _ready() -> void:
	_draw_roster()
	
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
	character_btn.data = data
	
	character_btn.mouse_hover.connect(_update_poster.bind(character_btn.data))
	character_btn.mouse_exited.connect(_update_poster.bind(null))
	
func _clear_roster():
	if _roster_root.get_children().is_empty(): return
	for i in _roster_root.get_children(): i.queue_free()


func _on_menu_button_pressed() -> void:
	if !p1_data && !p2_data: GameManager.main_menu()
