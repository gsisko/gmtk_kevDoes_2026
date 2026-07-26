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

@export_group("Sounds", "_sfx")
@export var _sfx_hover:AudioStream
@export var _sfx_pressed:AudioStream

func _ready() -> void:
	_update_display()

func _update_display():
	if !_label: return
	_label.text = _text
	size = _btn_size

func _on_pressed() -> void: 
	if disabled:return
	AudioManager.play_sfx(_sfx_pressed)

func _on_focus_entered() -> void: 
	if disabled:return
	AudioManager.play_ui_sfx(_sfx_hover)
func _on_mouse_entered() -> void: 
	if disabled:return
	AudioManager.play_ui_sfx(_sfx_hover)
