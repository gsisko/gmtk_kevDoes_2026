extends Resource
class_name Character_Data

@export var name:String = "Character"
@export var desc:String = "This is the Gun McShoota Man"

@export var sprite_sheet: Texture
@export var sprite_scale: Vector2 = Vector2(0.5, 0.5)

@export var portrait: Texture

@export_group("SFX", "sfx")
@export var sfx_shoot: AudioStream = preload("uid://cb25dwl75abge")
@export var sfx_hit: AudioStream = preload("uid://brygf5byvco58")
@export var sfx_character_noise: AudioStream
