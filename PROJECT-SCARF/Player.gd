extends KinematicBody2D
var direction = 1
export var speed = 200
var velocity = Vector2.ZERO
export var gravity = 0
export var jump = 500
var double_jump = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	
func sprite_direction():
	if direction == 1:
		$Idle.flip_h = false
		$Walk.flip_h = false
	else:
		$Idle.flip_h = true
		$Walk.flip_h = true
	
	
func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		direction = 1
		$AnimationPlayer.play("Walk")
		
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		direction = -1
		$AnimationPlayer.play("Walk")
		
		
	if velocity.x == 0:
		
		$AnimationPlayer.play("Idle")
		$Walk.hide()
		$Idle.show()
	
	if velocity.x != 0:
		
		$AnimationPlayer.play("Walk")
		$Idle.hide()
		$Walk.show()
	
	if is_on_floor():
		
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump
			double_jump = true
	
		
		
func _physics_process(delta):
	get_input()
	sprite_direction()
	print(velocity.y)
	
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity,Vector2.UP)

	
	

	
	
