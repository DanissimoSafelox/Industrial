extends CharacterBody2D
# код визора. 

enum {
	IDLE,
	WANDER,
	CHASE,
	DEATH
}


var ACCELERATION = 200 # Горизонтальное ускорение
var MAX_SPEED = 40 # Максимальная горизонтальная скорость
var FRICTION = 0.25 # Горизонтальное замедление
var JUMP_FORCE = 280.0 # Сила прыжка

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = IDLE

		

func _physics_process(delta):

	match state: # выбор состояний
		IDLE:
			idle_state(delta)
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)
		DEATH:
			death_state(delta)
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	
	move_and_slide()




									#СОСТОЯНИЕ ПОКОЯ
func idle_state(delta): 
	$AnimationPlayer.play("idle")
	velocity.x = lerp(velocity.x, 0.0, FRICTION)



									#СОСТОЯНИЕ БРОДИЛКИ (ПОИСКА ЦЕЛИ ПОСЛЕ УХОДА ИЗ ЗОНЫ ВИДИМОСТИ)
func wander_state(delta): 
	var player = $Vision_zone.player
	if player: # Если цель в зоне
		var direction = (player.global_position - global_position).normalized()# Вообще дирекшн это вектор, у которого есть длина (длина до цели). Нормализация - делает просто направление
		#Прыжок
		if is_on_floor():
			if not $Pit_detector.is_colliding() and direction.y <= 0.2:
				velocity.y = -JUMP_FORCE
			elif $Platform_detector.is_colliding() and direction.y <= -0.2 and player.is_on_floor():
				velocity.y = -JUMP_FORCE
		###Двигаемся
		moving(delta, direction)
	else:
		$Wandering_time.stop()
		state = IDLE



									#СОСТОЯНИЕ ПРЕСЛЕДОВАНИЯ
func chase_state(delta): 
	$AnimationPlayer.play("run")
	
	var player = $Vision_ray.target
	if player: # Если цель видно
		var direction = (player.global_position - global_position).normalized()# Вообще дирекшн это вектор, у которого есть длина (длина до цели). Нормализация - делает просто направление
		#Прыжок
		if is_on_floor():
			if not $Pit_detector.is_colliding() and direction.y <= 0.2:
				velocity.y = -JUMP_FORCE
			elif $Wall_detector.is_colliding():
				velocity.y = -JUMP_FORCE
			elif $Platform_detector.is_colliding() and direction.y <= -0.2 and player.is_on_floor():
				velocity.y = -JUMP_FORCE
		###Двигаемся
		moving(delta, direction)

	else: # если цель не видно, то начинается поиск цели
		state = WANDER
		$Wandering_time.start()



									#СОСТОЯНИЕ УМИРАНИЯ
func death_state(delta): 
	$AnimationBlink.play("death")


func moving(delta, direction):
	if direction.x > 0:
		$Hit_Box.knockback_vector = 1
		
	elif direction.x < 0:
		$Hit_Box.knockback_vector = -1
	
	velocity.x += direction.x * ACCELERATION * delta #Ускоряемся
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED) # Держим в рамках
	if direction.x < 0:# В зависимости от направления отражает спрайты и зону видимости
		$Main_sprite.flip_h = true
		$Vision_zone.scale.x = -1
		$Platform_detector.target_position.x = -30
		$Platform_detector.position.x = -5
		$Wall_detector.target_position.x = -10
	else:
		$Main_sprite.flip_h = false
		$Vision_zone.scale.x = 1
		$Platform_detector.target_position.x = 30
		$Platform_detector.position.x = 5
		$Wall_detector.target_position.x = 10

										# Функция создания одиночного звука
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


func _on_health_stat_no_health():#Как только хп опускается до нуля меняем состояние на смерть
		state = DEATH
		


func _on_vision_ray_is_visible():#Если нащ рейкаст засёк игрока
	$Wandering_time.stop()
	state = CHASE


func _on_wandering_time_timeout(): #Как только время поиска пройдёт, преследование прекратится
	state = IDLE
