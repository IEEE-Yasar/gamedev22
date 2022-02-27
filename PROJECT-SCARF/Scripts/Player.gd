extends KinematicBody2D
var velocity = Vector2.ZERO
export var speed = 300
export var maxSpeed = 500
export var gravity = 300
export var jump_speed = -250
export var dash_duraction = 0.2
export var health = 100
var attack_damage = 25
onready var dash = $Dash
enum state {IDLE,WALK,JUMP,FALL,LATTACK,HATTACK}
var player_state = state.IDLE
var isAttacking = false
var double_jump = false
var jumploop = false
var airdash = true
var jumponce = true
var direction
var spawn_position



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
		velocity.x += movement * speed * delta * 4
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
			attack_damage = 25
			isAttacking = true
			player_state = state.LATTACK
			
			
		if Input.is_action_just_pressed("heavy_attack"):
			isAttacking = true
			player_state = state.HATTACK
			attack_damage = 20
			yield(get_tree().create_timer(0.5),"timeout")
			attack_damage = 30
			
			
		if is_on_floor():
			airdash = true
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
			velocity.y = jump_speed -100
			player_state = state.JUMP
			double_jump = false
	
	if Input.is_action_just_pressed("space") && dash.can_dash ==true: #Dash
		if is_on_floor():
			dash.start_dash($Sprite, dash_duraction)
			if movement !=0:
				velocity.x = 2000 * direction
			else:
				velocity.x = 20000 * direction
		elif not is_on_floor() and airdash == true:
			dash.start_dash($Sprite, dash_duraction)
			if movement !=0:
				velocity.x = 2000 * direction
			else:
				velocity.x = 20000 * direction
			airdash = false
			
			
			
		
	if position.y >= 900:			#If you fall you will return to first position
		position = spawn_position
		
	if $Sprite.flip_h == true:			#Direction
		direction = -1
		$DashSprite.position.x = 225
		$DashSprite.position.y = 3
		$DashSprite.rotation_degrees = 90
		$Sword/LightAttack.position.x = -30
		$Sword/LightAttack.position.y = 2.75
		$Sword/LightAttack.rotation_degrees = 0
		$Sword/HeavyAttack.position.x = 3.25
		$Sword/HeavyAttack.position.y = 12.5
		$Sword/HeavyAttack.rotation_degrees = 0
		$Sword/HeavyAttack2.position.x = -29
		$Sword/HeavyAttack2.position.y = 0
		$Sword/HeavyAttack2.rotation_degrees = 0
		
	else:
		direction = 1
		$DashSprite.position.x = -221
		$DashSprite.position.y = 8
		$DashSprite.rotation_degrees = -90
		$Sword/LightAttack.position.x = 25.5
		$Sword/LightAttack.position.y = 5.5
		$Sword/LightAttack.rotation_degrees = 0
		$Sword/HeavyAttack.position.x = -4.5
		$Sword/HeavyAttack.position.y = 12.5
		$Sword/HeavyAttack.rotation_degrees = 0
		$Sword/HeavyAttack2.position.x = 30
		$Sword/HeavyAttack2.position.y = 1
		$Sword/HeavyAttack2.rotation_degrees = 0


	if dash.is_dashing():
		$DashSprite.show()
	else:
		$DashSprite.hide()

	print("attack damage: ", attack_damage)
	Global.player_attack = attack_damage
	update_anim()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
	
	
		
	
	
