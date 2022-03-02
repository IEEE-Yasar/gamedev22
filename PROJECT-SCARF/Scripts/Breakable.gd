extends Area2D
export var respawn_time = 3

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$anim.play("Destroy")
		yield($anim,"animation_finished")
		$CollisionShape2D.disabled = true
		$StaticBody2D/BodyCollision.disabled = true
		$Sprite.hide()
		yield(get_tree().create_timer(respawn_time),"timeout")
		$Sprite.show()
		$anim.play("Respawn")
		yield($anim,"animation_finished")
		$anim.play("Active")
