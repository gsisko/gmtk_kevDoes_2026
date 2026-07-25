@tool
extends TextureButton

signal clicked

@onready var _label:Label = $Label

@export var _text:String:
	set(update): 
		_text = update
		_label.text = _text
@export var _btn_size:Vector2 = Vector2(200, 100):
	set(update):
		_btn_size = update
		size = _btn_size

func _ready() -> void:
	_text = _text
	_btn_size = _btn_size
