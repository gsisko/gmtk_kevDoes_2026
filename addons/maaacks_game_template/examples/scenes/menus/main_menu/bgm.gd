extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._bgm_player: return
	var copy := self.duplicate()
	AudioManager._bgm_player = copy
	AudioManager.root.add_child(copy)
