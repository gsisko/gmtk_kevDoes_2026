@tool
extends TextureButton

@export var _label: Label

@export var _text:String:
	set(update): 
		_text = update
		_update_display()
@export var _btn_size:Vector2 = Vector2(200, 100):
	set(update):
		_btn_size = update
		_update_display()

func _ready() -> void:
	_update_display()

func _update_display():
	if !_label: return
	_label.text = _text
	size = _btn_size
