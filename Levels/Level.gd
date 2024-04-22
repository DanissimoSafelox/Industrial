extends Node2D
class_name Level


@export_category("Лимит камеры")
@export var camera_area: ColorRect
@export var dialoger: CUBEMASTER
@export var Background: Sprite2D
@export var OuterWorld: TileMap
@onready var World = get_parent()

signal level_create

func _ready():
	var parent = get_parent()
	if parent is GameWorld:# здесь мы Миру присваиваем значение текущего уровня свой при появлении
		parent.current_level = self #											  v  это перенос

		if camera_area:
			parent.set_camera_limits(camera_area.position.x, camera_area.position.y,\
			camera_area.position.x +  camera_area.size.x,\
			camera_area.position.y +  camera_area.size.y)#^ ЭТО ТОЖЕ ПЕРЕНОС
			camera_area.visible = false
			
	

func start_dialog():
	if dialoger:
		Background.modulate = Color(0,0,0,1)
		OuterWorld.modulate = Color(0,0,0,1)
		World.player.start_dialog()
		dialoger.Dialog_caption.play("hide")
		World.play_world_message(World.text_dialogs.cube_greetings)


func end_dialog():
	if dialoger:
		Background.modulate = Color(0.19,0.73,0.98,1)
		OuterWorld.modulate = Color(1,1,1,1)
