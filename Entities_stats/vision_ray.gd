extends RayCast2D

enum follow_state {#Состояние слежения - либо направляем рейкаст по всем координатам, либо по одной
	ALL_AXIS,
	ONLY_X,
	
}

@export var vision_zone: Vision_zone#НЕ ЗАБУДЬ УКАЗАТЬ ПРИ НАЛИЧИИ
@export var following: follow_state = follow_state.ALL_AXIS

var target: Player = null

signal is_visible





func _physics_process(delta):
	#print(position_correct)
	if is_colliding() and get_collider() is Player:#Проверяем что луч сталкивается с игроком
		target = get_collider()# вставляем в таргет сущность игрока	
	else:
		target = null
	
	
	if vision_zone.player:# При видимости игрока в зоне
		match following:
			0:
				target_position = vision_zone.player.global_position - global_position# Направляем конец стрелки рейкаста в точку игрока
			1:
				target_position.x = vision_zone.player.global_position.x - global_position.x# Направляем конец стрелки рейкаста в точку игрока
		

	else:
		target_position = Vector2.ZERO#Убираем стрелку
	
	
	if target: # Если цель видна (на пути рейкаста нету препятствий)
		emit_signal("is_visible")

	
