extends KinematicBody2D
export var speed = 400
export var maxSpeed = 600
var velocity = Vector2.ZERO
export var gravity = 300
export var jump_speed = -250
export var dash_speed = 6000
export var dash_duraction = 0.4
onready var dash = $Dash
enum state {IDLE,WALK,JUMP,FALL,LATTACK,HATTACK}
var isAttacking = false
var player_state = state.IDLE
var double_jump = false
var jumploop = false
var attackstackl = 0
var spawn_position
var jumponce = true
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = position
	
	
func update_anim():
	match(player_state):
		state.IDLE:
			$AnimationPlayer.play("Idle")
		state.WALK:
			$AnimationPlayer.play("Walk")
		state.JUMP:
			if jumploop == false:
				$AnimationPlayer.play("Jump")
				yield($AnimationPlayer,"animation_finished")
				jumploop = true
		state.FALL:
			$AnimationPlayer.play("Fall")
			jumploop = false
		state.LATTACK:
			$AnimationPlayer.play("LightAttack")
			yield($AnimationPlayer,"animation_finished")
			isAttacking = false
			if is_on_floor():
				player_state = state.IDLE
			elif not is_on_floor() and velocity.y < 0:
				player_state = state.JUMP
			elif not is_on_floor() and velocity.y > 0:
				player_state = state.FALL
			
				
		state.HATTACK:
			$AnimationPlayer.play("HeavyAttack")
			yield($AnimationPlayer,"animation_finished")
			isAttacking = false
			if is_on_floor():
				player_state = state.IDLE
			elif not is_on_floor() and velocity.y < 0:
				player_state = state.JUMP
			elif not is_on_floor() and velocity.y > 0:
				player_state = state.FALL
	
	

func _physics_process(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement != 0:
		velocity.x += movement * speed * delta * 1.5
		$Sprite.flip_h = movement < 0
		if not dash.is_dashing():
			velocity.x = clamp(velocity.x,-maxSpeed,maxSpeed)
			
		
	elif movement ==0:
		velocity.x = 0
		
	if player_state !=state.LATTACK and player_state != state.HATTACK:
		
		if velocity.x ==0:
			player_state = state.IDLE
		
		elif velocity.x !=0:
			player_state = state.WALK
			
		if Input.is_action_just_pressed("light_attack"):
			isAttacking = true
			player_state = state.LATTACK
			
			
		if Input.is_action_just_pressed("heavy_attack"):
			isAttacking = true
			player_state = state.HATTACK
			
			
		if is_on_floor():
			jumponce = true
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = jump_speed
				player_state = state.JUMP
				double_jump = true
	
	if not is_on_floor():
		if velocity.y < 0 and isAttacking == false:
			player_state = state.JUMP
		elif velocity.y > 0 and isAttacking == false:
			player_state = state.FALL
		if Input.is_action_just_pressed("ui_up") && jumponce == true:
				velocity.y = jump_speed
				player_state = state.JUMP
				jumponce = false
		if Input.is_action_just_pressed("ui_up") and double_jump == true:
			jumploop = false
			velocity.y = jump_speed
			player_state = state.JUMP
			double_jump = false
	
	if Input.is_action_just_pressed("space") && dash.can_dash ==true: #Dash
		dash.start_dash($Sprite, dash_duraction)
		if movement !=0:
			velocity.x = 1000 * direction
		else:
			velocity.x = 15000 * direction
		
	if position.y >= 900:			#If you fall you will return to first position
		position = spawn_position
		
	if $Sprite.flip_h == true:
		direction = -1
		$DashSprite.position.x = 225
		$DashSprite.position.y = 3
		$DashSprite.rotation_degrees = 90
		
	else:
		$DashSprite.position.x = -221
		$DashSprite.position.y = 8
		$DashSprite.rotation_degrees = -90
		direction = 1	


	if dash.is_dashing():
		$DashSprite.show()
	else:
		$DashSprite.hide()


	print(velocity.x)
	update_anim()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
	
	
		
	
	
