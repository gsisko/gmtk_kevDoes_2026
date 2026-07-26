extends Control
class_name Character_Button

signal pressed(data:Character_Data)
signal mouse_hover(data:Character_Data)

@export var data:Character_Data

func _on_button_pressed() -> void: pressed.emit(data)
func _on_button_mouse_entered() -> void: mouse_hover.emit(data)
