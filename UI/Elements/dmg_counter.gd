extends Label
class_name DamageCounter


@onready var _anim:AnimationPlayer = $AnimationPlayer



func launch(dmg:float):
	text = str(int(dmg))
	_anim.play("show")
