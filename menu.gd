extends Control


@export var Main_menu: PackedScene#Пакетная сцена - берём главное меню


func _on_button_resume_pressed():
	owner.get_tree().paused = false
	visible = false


func _on_button_exit_pressed():
	owner.get_tree().paused = false
	get_tree().change_scene_to_packed(Main_menu)
