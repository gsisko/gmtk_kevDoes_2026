@tool
extends Control
class_name CharacterProfile

@onready var player_label: Label = %playerLabel
@onready var character_label:Label = %character_name


@export var player_id: int : 
	set(update):
		player_id = update
		_update_player_label()

func _ready() -> void:
	_update_player_label()

func set_data(data:Character_Data):
	var _name:String = ""
	if data: _name = data.name
	
	character_label.text = _name

func _update_player_label():
	if !player_label: return
	player_label.text = "P"+str(player_id)
