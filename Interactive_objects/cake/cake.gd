extends Node2D



func _on_health_stat_no_health():
	print("ЗОЧЕМ???")
	queue_free()


func _on_take_box_body_entered(body):
	body.emit_signal("eat_cake")
	print("НЯМ")
	queue_free()
