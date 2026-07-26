extends TextureRect
class_name WantedPoster

@onready var portrait:TextureRect = %Portrait
@onready var holes:Control = %Holes

@export var is_marked: bool = false
@export var _data:Character_Data

func _ready() -> void:
	_update_display()

func set_data(data:Character_Data):
	_data = data
	_update_display()
	
func _update_display():
	if _data: portrait.texture = _data.portrait
	else: portrait.texture = null
	if holes.visible && !is_marked: holes.hide()
	elif !holes.visible && is_marked: holes.show() 
