@tool
extends Control
class_name AmmoToken

@onready var _sprite:TextureRect = $TextureRect

@export var _active_color: Color
@export var _deactive_color: Color

@export var is_active:bool = true :
	set(update):
		if is_active == update: return
		is_active = update
		
		if !is_active: _on_deactive()
		else: _on_active()
	
func _on_deactive(): 
	if !_sprite: return
	_sprite.modulate = _deactive_color
func _on_active():
	if !_sprite: return
	_sprite.modulate = _active_color
	
