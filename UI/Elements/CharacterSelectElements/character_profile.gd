@tool
extends Control

@onready var player_label: Label = %playerLabel
@onready var character_label:Label = %character_name


@export var player_id: int : 
	set(update):
		player_id = update
		_update_player_label()

func _ready() -> void:
	player_label = player_label
	character_label=character_label
	_update_player_label()

func set_data(data:Character_Data):
	character_label.text = data.name


func _update_player_label():
	if !player_label: return
	player_label.text = "P"+str(player_id)
