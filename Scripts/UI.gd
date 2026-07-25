extends Control
class_name UI

@export var main_menu_path:String
@onready var hud:HUD = %Hud
@onready var _overlay_root: Control = %Overlay_Root

static var instance:UI

enum OVERLAY {Main_Menu, Victory, Character_Select}

@export var result_scene:PackedScene
@export var character_select: PackedScene

func _ready() -> void:
	if !UI.instance: UI.instance = self

func show_hud():
	if !hud || hud.visible: return
	hud.show()
func close_hud():
	if !hud || !hud.visible: return
	hud.hide()
	
	
#func _load_overlay(overlay:OVERLAY)->Control:
	#match overlay:
		#OVERLAY.Main_Menu: 

static func open_overlay(overlay:OVERLAY)->Control:
	var opened:Control 
	match overlay:
		OVERLAY.Victory: opened = instance._load_overlay_scene(instance.result_scene)
		OVERLAY.Character_Select: opened = instance._load_overlay_scene(instance.character_select)
	return opened

func _load_overlay_scene(overlay_scene:PackedScene) -> Control:
	var overlay:Control = overlay_scene.instantiate()
	if !overlay: 
		push_error("Error Creating Overlay")
		return null
	for i in instance._overlay_root.get_children():
		i.queue_free()
	instance._overlay_root.add_child(overlay)
	return overlay
