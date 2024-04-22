extends StaticBody2D

@export var damage = 1
@export var bullet_speed = 250
@export var look_to_left = false
var bullet = preload("res://Effects/missle.tscn")



func _ready():
	if look_to_left:
		$LOOK.play("LEFT")
		bullet_speed = bullet_speed * (-1)
	else:
		$LOOK.play("RIGHT")
		


func create_one_sound(path : String): 
	var sound = AudioStreamPlayer.new()
	add_child(sound)
	sound.finished.connect(clear_one_sound.bind(sound))
	sound.stream = load(path)
	sound.play()
	
										# Функция удаления одиночного звука
func clear_one_sound(name): 
	name.queue_free()



func _on_animation_blink_animation_finished(anim_name):#Как только заканчивается анимация смерти
	if anim_name == "death":
		queue_free()#умираем


func _on_health_stat_no_health():#Хп кончается - умираем
	$AnimationBlink.play("death")



func create_bullet():# создание пульки
	var new_bullet = bullet.instantiate() # в переменной содержится экземпляр
	new_bullet.position = $Bullet_launcher.global_position# задаем позицию
	new_bullet.set_axis_velocity(Vector2(bullet_speed,0))# Задаем велосити
	new_bullet.damage = damage# задаем урон
	owner.add_child(new_bullet)#Вроде как добавляем в корневую сцену (дерево,чётш-там)



func _on_animation_player_animation_finished(anim_name):#При окончании анимации атаки - проверяем, есть ли ещё враг в зоне
	if anim_name == "attack":
		if $Vision_ray.target:# Плеер виден
			$AnimationPlayer.play("attack")
		else: # Плеер не виден
			$AnimationPlayer.play("idle")


func _on_vision_ray_is_visible():
	$AnimationPlayer.play("attack")
