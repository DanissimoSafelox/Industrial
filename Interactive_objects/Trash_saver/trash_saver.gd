extends Node2D

var coin = preload("res://Effects/coin.tscn")

func _on_sprite_trash_saver_animation_finished():
	queue_free()#Реальна умираем :(



	
func _on_health_stat_no_health():
	var new_coin = coin.instantiate()#генерируем монетОчку\
	new_coin.position = $Coin_extractor.global_position
	new_coin.set_axis_velocity(Vector2(randf_range(-60,60),-randf_range(100,200)))# Задаем велосити
	randomize()
	owner.call_deferred("add_child", new_coin)
	#owner.add_child(new_coin)
	$SpriteTrashSaver.play("death") # красиво умираем
