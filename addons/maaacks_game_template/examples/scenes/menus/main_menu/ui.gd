extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._ui_player: return
	var copy:= self.duplicate()
	AudioManager._ui_player = copy
	AudioManager.root.add_child(copy)
