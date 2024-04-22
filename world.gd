extends Node2D

class_name GameWorld

@export var start_level: PackedScene
@export var memory: Saves
@export var text_dialogs: TextDialogs
@onready var current_level = start_level
@onready var UI = $CanvasLayer/UI
@onready var Menu = $CanvasLayer/Menu
@onready var player = $Player
@onready var WorldMessage = $CanvasLayer/World_message


var entry_door: GameDoor
var current_dialoger: String

func _ready():
	WorldMessage.visible = false
	$CanvasLayer/UI/Label_coin.text = str(memory.cash)
	UI.draw_hp_cells($Player/Health_stat.MAX_HEALTH)
	UI.draw_health($Player/Health_stat.health)
	Menu.visible = false
	var Level_on_start = start_level.instantiate()
	add_child(Level_on_start)
	


func set_camera_limits(left, top, right, bot): # вызывается из только что появившегося уровня
	$Camera2D.limit_bottom = bot
	$Camera2D.limit_top = top
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right


func change_levels(door):
	current_level.queue_free()
	var NewLevel = load(door.exit_scene)
	var newLevel = NewLevel.instantiate()
	add_child(newLevel)
	
	var new_door = get_new_player_pos(door)
	$Player.global_position = new_door.global_position
	$Player.velocity = new_door.exit_vector
	$CanvasLayer/UI/AnimationShade.play("UnShading")

func get_new_player_pos(door):
	var doors = get_tree().get_nodes_in_group("Door")
	for one_door in doors:
		if one_door.exit_scene == door.current_scene:
			return one_door


func show_death_screen():
	$CanvasLayer/UI/AnimationShade.play("death_shade")



func save_memory():
	ResourceSaver.save(memory)


func load_memory():
	pass


func _on_player_boy_next_door(door): #При заходе в дверь
	$CanvasLayer/UI/AnimationShade.play("Shading")# всё тухнет, потом меняются уровни
	entry_door = door# задействуем потом
	$Player.velocity = door.enter_vector #засасываем
	


func _on_health_stat_taking_damage(): # при получении урона отображение хп изменяется
	UI.draw_health($Player/Health_stat.health)


func _on_animation_shade_animation_finished(anim_name):
	if anim_name == "death_shade":
		get_tree().change_scene_to_packed(Menu.Main_menu)
	
	if anim_name == "Shading":
		call_deferred("change_levels", entry_door)
		#значит так: вот две функции
		#call_deferred("change_levels", door) это пойдёт (она ожидает следующий тик в процессе)
		#change_levels(door) это нет
		#так как вызывается много ошибок коллизии



func _on_player_pause_menu():
	Menu.visible = true
	get_tree().paused = true


func _on_player_update_cash(value):
	if memory.cash + value >= 0:
		memory.cash += value
		$CanvasLayer/UI/Label_coin.text = str(memory.cash)
		




func _on_player_dialog_button_change(new_dialoger):
	current_dialoger = new_dialoger
	if current_dialoger != "":
		$CanvasLayer/UI/BLADE_button.visible = false
		$CanvasLayer/UI/DIALOG_button.visible = true
	else:
		$CanvasLayer/UI/BLADE_button.visible = true
		$CanvasLayer/UI/DIALOG_button.visible = false

func play_world_message(message: String):
	$CanvasLayer/World_message/Label.text = message
	$CanvasLayer/World_message/AnimationPlayer.play("show")


func _on_player_interact():
	if current_dialoger == "cube":
		current_level.start_dialog()
		WorldMessage.visible = true
		


func _on_player_next_dialog():
	WorldMessage.visible = false
	player.state = player.MOVE
	current_level.end_dialog()
