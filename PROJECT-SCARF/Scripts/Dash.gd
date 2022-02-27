extends Node2D

onready var duraction_timer = $Timer

var can_dash = true
export var dash_delay = 0.8

var sprite

func start_dash(sprite,duraction):
	self.sprite = sprite
	duraction_timer.wait_time = duraction
	duraction_timer.start()
	
	
	
	
func is_dashing():
	return !duraction_timer.is_stopped()
	


func end_dash():
	
	can_dash = false
	yield(get_tree().create_timer(dash_delay), "timeout")
	can_dash = true
	


func _on_Timer_timeout() -> void:
	end_dash()


