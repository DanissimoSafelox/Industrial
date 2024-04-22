extends Node2D



@export var dialoger_name: String
@export var push_caption: String 

func _ready():
	$Label.text = "<" + push_caption + ">"




func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("show")
	body.emit_signal("dialog_button_change", dialoger_name)

func _on_area_2d_body_exited(body):
	$AnimationPlayer.play("hide")
	body.emit_signal("dialog_button_change", "")
