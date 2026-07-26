extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._bmg_player: return
	AudioManager._bmg_player = self
	reparent(AudioManager.root)
