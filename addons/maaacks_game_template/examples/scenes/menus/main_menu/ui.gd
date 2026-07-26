extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._ui_player: return
	AudioManager._ui_player = self
	reparent(AudioManager.root)
