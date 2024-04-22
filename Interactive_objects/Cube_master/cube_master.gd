extends Node2D #Кубмастер
class_name CUBEMASTER





@export var CAKE: PackedScene
@onready var PLAYER = get_parent().get_parent().player
@onready var World = get_parent().get_parent()# Это мир
@onready var Dialog_caption = $Dialoger/AnimationPlayer
