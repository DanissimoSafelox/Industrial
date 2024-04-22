extends Area2D


#Здесь мы обрабатывает входящий хитбокс (Входящий урон + отбрасывание)
@export var health_stat: Health_stat# на всякий случай, чтобы не выбрать другую ноду
#НЕ ЗАБЫВАЙ УСТАНОВИТЬ ЗНАЧЕНИЕ ЭЙ ТЫ

signal player_take_knockback


func _on_area_entered(area): #Вхождение хитбокса в наш хартбокс
	if health_stat:
		health_stat.take_damage(area.DAMAGE)
	
	if get_parent().get_class() == "CharacterBody2D": #Проверка явдяется ли носитель хартбокса чарбади
		if get_parent() is Player and health_stat.health != 0:
			emit_signal("player_take_knockback") #Сигнал о том, что игрока отбрасывают (нужно переключить состояние)
		#else:
		get_parent().velocity.x = area.knockback_vector * area.KNOCKBACK_POWER#Если да, то применяем отдачу
	
	
