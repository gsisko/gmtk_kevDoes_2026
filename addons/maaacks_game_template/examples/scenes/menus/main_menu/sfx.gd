extends AudioStreamPlayer

func _ready() -> void:
	if AudioManager._sfx_player: return
	AudioManager._sfx_player = self
	reparent(AudioManager.root)
