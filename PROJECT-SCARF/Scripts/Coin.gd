extends Area2D





func _on_Coin_body_entered(body):
	if body.has_method("coinPickup"):
		body.coinPickup()
		$AnimationPlayer.play("Picked")
		yield(get_tree().create_timer(0.4), "timeout")
		
		
		queue_free()
	
	
	
	

