extends Control
class_name VictoryMenu

@export var _data: Character_Data :
	set(update):
		_data = update
		_update_menu()

@onready var charName:Label = %Char_Name
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _poster:WantedPoster = $WantedPoster
func _update_menu():
	charName.text = _data.name
	_sprite.texture = _data.sprite_sheet

func set_winner(data:Character_Data): _data = data
func set_loser(data:Character_Data): _poster.set_data(data)
	
func _on_rematch_btn_clicked() -> void:
	print("rematch")
	GameManager.start_game()
	queue_free()
func _on_menu_btn_clicked() -> void:
	print("main_menu")
	GameManager.main_menu()
