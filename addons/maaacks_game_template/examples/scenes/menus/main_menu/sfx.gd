extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._sfx_player: return
	var copy:= self.duplicate()
	AudioManager._sfx_player = copy
	AudioManager.root.add_child(copy)
