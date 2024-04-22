extends RigidBody2D

class_name Missle


var damage = 0

func _ready():
	$Hit_Box.DAMAGE = damage

	
	

func _on_hit_box_area_entered(area):
	queue_free()


func _on_area_2d_body_entered(body):
	queue_free()
