extends Control
class_name Character_Button

signal pressed(data:Character_Data)
signal mouse_hover(data:Character_Data)

@export var data:Character_Data
@onready var poster: WantedPoster = $WantedPoster

func set_poster_data(new_data:Character_Data):
	data = new_data
	poster.set_data(data)

func _on_button_pressed() -> void: 
	print("PRESSED THE BUTTON!!!!")
	pressed.emit(data)
func _on_button_mouse_entered() -> void: 
	print("HOVERERRERS THE BUTTON!!!!")
	mouse_hover.emit(data)
