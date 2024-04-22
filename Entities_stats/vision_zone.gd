extends Area2D

class_name Vision_zone


var player = null

	

func _on_body_entered(body):
	player = body
	#print("ВХОДИТ")
	

func _on_body_exited(body):
	player = null
	#print("ВЫХОДИТ")
