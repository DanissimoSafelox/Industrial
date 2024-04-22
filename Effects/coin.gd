extends RigidBody2D


const money_value = 1

func _on_take_area_body_entered(body):
	body.emit_signal("update_cash",money_value)
	body.create_one_sound("res://Sounds/Coin_take.wav")
	queue_free()
