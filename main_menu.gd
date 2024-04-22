extends Control
#Главное меню
var world = "res://world.tscn"#файл сцена - берём стартовую локацию


func _on_button_start_game_pressed():#Перемещаемся к выбранной пакетной сцене
	get_tree().change_scene_to_file(world)
	
	


func _on_button_exit_pressed():#Выходим из этой параши
	get_tree().quit()
