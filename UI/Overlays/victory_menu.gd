extends Control
class_name VictoryMenu

@export var _data: Character_Data :
	set(update):
		_data = update
		_update_menu()

@onready var charName:Label = %Char_Name
@onready var _sprite: Sprite2D = %Sprite2D

func _update_menu():
	charName.text = _data.name
	_sprite.texture = _data.sprite_sheet

func set_winner(data:Character_Data): _data = data


func _on_rematch_btn_clicked() -> void:
	GameManager.battle_instance.start_battle()
	


func _on_menu_btn_clicked() -> void:
	pass # Replace with function body.
