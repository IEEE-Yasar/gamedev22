extends Area2D

#var coinScene = preload("res://Scenes/Coin.tscn")
var health = 50
func _on_Crates_area_entered(area):
	
	if area.is_in_group("Sword"):
		health -= Global.player_attack
		$anim.play("Slashed")
		yield(get_node("anim"), "animation_finished")
		$anim.play("Active")
		
		if health <= 0:
			$anim.play("Destroy")
			yield(get_node("anim"), "animation_finished")
			#onDestroyed()
			queue_free()
			
func onDestroyed():
	#var coin = coinScene.instance()
	#coin.global_position = global_position
	#get_tree().get_root().add_child(coin)
	pass
	

	

	
	

	
	
