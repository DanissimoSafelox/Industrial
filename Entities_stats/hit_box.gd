extends Area2D
#Здесь храним данные урона и отбрасывания
@export var DAMAGE = 3
@export var KNOCKBACK_POWER = 150
var knockback_vector = 0 #Вектор отбрасывания врага. Берется от направления движения
