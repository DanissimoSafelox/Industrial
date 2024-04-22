extends Area2D
class_name GameDoor

@export_file("*.tscn") var current_scene :String
@export_file("*.tscn") var exit_scene :String # сюда мы помещаем сцену, из которой выходим
@export var enter_vector = Vector2() # это вектор засасывания
@export var exit_vector = Vector2()# Это вектор выталкивания


func _on_body_entered(body):
	body.emit_signal("boy_next_door", self)# Тело, которое вошло (только игрок) испускает сигнал
	
	
