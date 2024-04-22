extends Control

var health_pos = 0.0

func _ready():# задаём кнопкам соответсвующие им действия
	$DASH_button.action = "dash"
	$BLADE_button.action = "attack"
	$UP_button.action = "ui_up"
	$LEFT_button.action = "ui_left"
	$RIGHT_button.action = "ui_right"
	$DIALOG_button.action = "dialog"
	
	
func draw_hp_cells(new_max_health):#При обновлении макс здоровья
	$HP_bar/Cell.size.x = 36 * new_max_health # меняем размер батарейки
	$HP_bar/End_cell.position.x = 14 + 36 * new_max_health# двигаем конец батарейки

func draw_health(health):#Изменение хп триггерит это через мир
	#Присваиваем новое значение ключа (индекс дорожки, индекс ключа, значение)
	#Тут присваиваем старое
	$Animation_HP_bar.get_animation("Hp_change").track_set_key_value(1,0,Vector2(health_pos, 130.0))
	health_pos = 36 * health # помещаем в контейнер и из него присваиваем в этот
	$Animation_HP_bar.get_animation("Hp_change").track_set_key_value(1,1,Vector2(health_pos, 130.0))
	$Animation_HP_bar.play("Hp_change")#Пуск анимации (первый ключ - начальный, второй - конечный)
	


