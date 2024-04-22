extends Node2D
class_name Health_stat
#Это нода стата здоровья, которая обрабатывает входящий урон. Имеет хп, при потере владелец стата уничтожается

@export var blink: AnimationPlayer#НЕ ЗАБУДЬ УКАЗАТЬ ПРИ НАЛИЧИИ
@export var MAX_HEALTH = 10
@onready var health = MAX_HEALTH

signal no_health
signal taking_damage

func _ready():
	health = MAX_HEALTH


func take_heal(healing):
	health = min(health + healing, MAX_HEALTH)
	emit_signal("taking_damage")

func take_damage(damage): #Функция получение урона
	if blink: #Здесь анимация меняет кое-что
		blink.play("start")
	health -= damage
	emit_signal("taking_damage")
	
	if health <= 0:
		emit_signal("no_health") # Если нет хп, то испускаем сигнал
