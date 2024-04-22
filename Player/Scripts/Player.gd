extends CharacterBody2D																																																										#Хули палишь?

class_name Player

						#Добавить:
			# буферное время и время койота
			#анимации
			#атака
			#заклинания: будет возможность менять заклинания или горячие клавиши. Добавить дэш, фаерболл
			# + в будущем добавить магию притягивания (при касте притягивает врагов к шару, а при остановке каста - отбрасывает всех. действует на предметы, мобов и объекты)
			#


											#Базовые статы
@export var ACCELERATION = 250 # Горизонтальное ускорение
@export var MAX_SPEED = 70 # Максимальная горизонтальная скорость
@export var FRICTION = 0.25 # Горизонтальное замедление
@export var JUMP_FORCE = 230.0 # Сила прыжка
@export var DASH_FORCE = 180 # Сила дэша
@export var health_stat: Health_stat


var max_energy = 100
var current_energy = 60
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") # Гравитация
var jump_bufered = false


enum {
	MOVE,
	DASH,
	CAST,
	ATTACK,
	DEATH,
	DISCARDING,
	DIALOG}#Набор состояний

var state = MOVE#Базовое состояние
var dash_vector = Vector2(1,0)# вектор дэша

signal boy_next_door(door) #Подошли к деври. Сигнал запускает дверь, идёт сигнал от игрока
signal update_cash(value) #Изменение количества монеток (получение/покупка/бесплатная покупка)
signal pause_menu
signal eat_cake
signal interact
signal dialog_button_change(new_dialoger)
signal next_dialog


									#ФУНКЦИЯ ГОТОВНОСТИ (ИНИЦИАЛИЗАЦИЯ)
func _ready():
	pass
	



# ЗНАЧИТ ТАК: НА АНДРОИДЕ СЕЙЧАС is_action_just_pressed/released НЕ РАБОТАЮТ В ФИЗИЧЕСКОМ ПРОЦЕССЕ (ТОЛЬКО ПРОСТО В ПРОЦЕССЕ)
									#ФУНКЦИЯ ПРОЦЕССА (решаем проблему is_action_just_pressed/released на андроиде)
func _process(_delta):
	if Input.is_action_just_pressed("dialog"): #Кнопка диалога
		if state == DIALOG:
			emit_signal("next_dialog")
		else:
			emit_signal("interact")			# Отправляем сигнал в world
	
	
	if Input.is_action_just_pressed("open_menu"):
		emit_signal("pause_menu")
	if state == MOVE:
		if is_on_floor():#Если стоит на земле или прыжок койота активен
			$Timers/Coyot_time.start()# стоим на земле - койот активен

		if Input.is_action_just_pressed("ui_up"):
			
			$Timers/Bufer_time.start()
																					# V  ЭТО ПЕРЕНОС
		if not $Timers/Coyot_time.is_stopped() and not $Timers/Bufer_time.is_stopped()\
		and Input.is_action_pressed("ui_up"): # Жмешь прыгать - прыгаешь (если койот действует)
				if not $AudioStreamPlayer.playing:
					$AudioStreamPlayer.play()
				velocity.y = -JUMP_FORCE
				$Timers/Short_jump_time.start()#Как нажали, активируем - во время него мы можем остановить прыжок
				$Timers/Coyot_time.stop()#как нажали, сразу останавливаем
				
		
		#при падении если отпускаешь кнопку прыжка, то прыжок замедляется (ему присваивается слабый прыжок в
		#случае если у него был начальный прыжок больше ( это не позволяет при отпускании подпрыгивать бесконечно раз))
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2\
		and not is_on_floor() and not $Timers/Short_jump_time.is_stopped(): 	
			velocity.y = -JUMP_FORCE/2;# этот таймер для того, чтобы не передумывал лететь вверх, когда нинада, а именно когда прыгаешь
			
		
		if Input.is_action_just_pressed("attack") and $Timers/CD_attack.is_stopped(): #При атаке
			state = ATTACK
			
		if Input.is_action_just_pressed("dash") and $Timers/CD_dash.is_stopped(): # При дэше
			state = DASH
		




									#ФУНКЦИЯ ФИЗИЧЕСКОГО ПРОЦЕССА
func _physics_process(delta):
	
	match state: # выбор состояний
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		DASH:
			dash_state(delta)
		CAST:
			cast_state(delta)
		DEATH:
			death_state(delta)
		DISCARDING:
			discarding_state(delta)
		DIALOG:
			dialog_state(delta)
	
	if not is_on_floor() and state != DASH:
		velocity.y += GRAVITY * delta#применяем гравитацию
		velocity.y = min(velocity.y, JUMP_FORCE)#ограничивая максимальную скорость падения

	
	move_and_slide()



									#СОСТОЯНИЕ ПЕРЕДВИЖЕНИЯ
func move_state(delta): 
	var input_vector = Vector2.ZERO # Входной вектор горизонтального движения
	input_vector.x = Input.get_axis("ui_left", "ui_right") 
	#Передаём горизонтальное направление по действиям (отрицательное, положительное) 
	#вместо Input.get_action_strength("positive_action") - Input.get_action_strength("negative_action").
	if input_vector.x != 0: #Если движемся
		dash_vector.x = input_vector.x #Задаём направление дэша
		$Attack/Sword_HitBox.knockback_vector = input_vector.x #Передаём значение входящего вектора для переменной вектора отдачи для хитбокса меча
		if is_on_floor():# если на земле
			$AnimationPlayer.play("run")#Проигрываем анимацию бега
		else:
			$AnimationPlayer.play("idle")
		if input_vector.x < 0:#Определяем направление (если меньше 0, то поворачиваем спрайт игрока и отзеркаливаем узел атаки (спрайт+хитбокс_
			$Main_sprite.flip_h = true
			$Attack.scale.x = -1
		else:
			$Main_sprite.flip_h = false
			$Attack.scale.x = 1
		velocity.x += input_vector.x * ACCELERATION * delta #Ускоряемся
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED) #Вплоть до Макс скорости (значение удерживается в рамках макс скорости в обоих направлениях)
	
	if input_vector.x == 0 and is_on_floor(): #Если стоим
		$AnimationPlayer.play("idle")
		velocity.x = lerp(velocity.x, 0.0, FRICTION) #Интерполяция движения (плавное замедление)
	
	#ПЕРЕНОС В ПРОЦЕСС
	"""
	if is_on_floor():#Если стоит на земле
		if Input.is_action_just_pressed("ui_up"):# Жмешь прыгать - прыгаешь
			velocity.y = -JUMP_FORCE
	else:#если не стоишь, но при этом отпускаешь кнопку прыжка, то прыжок замедляется (ему присваивается слабый прыжок в
		#случае если у него был начальный прыжок больше ( это не позволяет при отпускании подпрыгивать бесконечно раз))
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2: 	
			velocity.y = -JUMP_FORCE/2;
	if Input.is_action_just_pressed("attack"): #При атаке
		state = ATTACK
		
	if Input.is_action_just_pressed("dash"): # При дэше
		state = DASH
	"""


									#СОСТОЯНИЕ АТАКИ
func attack_state(_delta): 
	if is_on_floor(): # Если стоишь на полу
		velocity.x = 0# ТО СТОИШЬ СМИРНО, если нет, то лети на**й
		velocity.y = 0
	$AnimationPlayer.play("sword_attack")
	



									#СОСТОЯНИЕ ДЭША
func dash_state(_delta): 
	velocity = dash_vector * DASH_FORCE
	$AnimationPlayer.play("dash")



									#СОСТОЯНИЕ КАСТА
func cast_state(_delta): 
	pass



									#СОСТОЯНИЕ УМИРАНИЯ
func death_state(_delta):
	GRAVITY = 0
	velocity = Vector2(0, 0)
	$AnimationBlink.play("death")
	

									#СОСТОЯНИЕ ДИАЛОГОВ
func dialog_state(_delta):
	pass




									#СОСТОЯНИЕ ОТБРАСЫВАНИЯ
func discarding_state(_delta): # Тут мы убираем меч,иначе он просто остаётся
	$Attack/Sword_HitBox/CollisionShape2D.disabled = true
	$Attack/Sprite_attackEffect.visible = false



									#Функция, которая вызывается по завершении анимации атаки
func attack_animation_finished(): 
	state = MOVE



									#Функция, которая вызывается по завершении анимации дэша
func dash_animation_finished(): 
	state = MOVE
	velocity.x = 0 #Ибо нех**й дальше лететь



										# Функция создания одиночного звука
func create_one_sound(path : String): 
	var sound = AudioStreamPlayer.new()
	add_child(sound)
	sound.finished.connect(clear_one_sound.bind(sound))
	sound.stream = load(path)
	sound.play()


func start_dialog():			# функция начала диалога
	state = DIALOG					# переходим в состояние диалога
	velocity.x = 0
	$AnimationPlayer.play("idle")




										# Функция удаления одиночного звука
func clear_one_sound(name_sound): 
	name_sound.queue_free()


func _on_health_stat_no_health():
	state = DEATH
	owner.show_death_screen()
	


func _on_hurt_box_player_take_knockback():
	if state != DEATH:
		$Timers/Discarding.start()
		state = DISCARDING

	


func _on_discarding_timeout(): #при завершении отбрасывания
	state = MOVE


func _on_animation_blink_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()#умираем



func _on_eat_cake():# Когда съели тортик
	$Timers/Cake_time.start()
	


func _on_cake_time_timeout(): # Когда прошло время
	$Health_stat.take_damage(1)
	$Timers/Cake_time.wait_time = 0.8
	$Timers/Cake_time.start()
