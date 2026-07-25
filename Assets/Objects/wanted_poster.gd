@tool
extends TextureRect

@onready var portrait:TextureRect = %Portrait
@onready var holes:TextureRect = $Holes
@export var is_marked: bool = false :
	set(update):
		is_marked = update
		if holes.visible && !is_marked:
			holes.hide()
		elif !holes.visible && is_marked:
			holes.show() 
		
		

@export var _data:Character_Data : 
	set(update):
		_data = update

func set_data(data:Character_Data):
	_data = data
func _update_data():
	if !_data:return
	portrait.texture = _data.portrait
