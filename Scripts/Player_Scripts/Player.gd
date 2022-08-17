extends KinematicBody2D


#stats
export var health: float = 3;
export var oxygen: float = 10;

export var max_speed: float = 5
export var acceleration: float = 5
export var deceleration: float = 5
export var jump_force: float  = 60
export var jump_dampening: float = 0.6
export var gravity: float = 400


#movement
var current_speed: float = 0
var velocity: Vector2 = Vector2.ZERO
var jump_vector: float = 0;
var jumping: bool = false


#attack
export var attack_damage: float = 1;
var attacking: bool = false;
var has_pick = true;
var pick_path = preload("res://Scenes/player_pick.tscn")
var toss_dir = 1;


var current_oxygen = oxygen;
var oxygen_reduction_ready: bool = true;
var oxygen_refill_ready: bool = true;
var land_sound_played: bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input();
	control_gfx();
	control_oxygen();
	
	pass
	

func get_input():
	if Input.is_action_pressed("move_right"):
		current_speed += acceleration
		toss_dir = 1;
	if Input.is_action_pressed("move_left"):
		toss_dir = -1;
		current_speed -= acceleration
		
	if(Input.is_action_just_pressed("jump")):
		_jump();
		
	if(Input.is_action_just_released("jump")):
		jumping = false;

	if(Input.is_action_just_pressed("drop")):
		drop();
	
	if(Input.is_action_just_pressed("attack")):
		attack();
		
	if(Input.is_action_just_pressed("toss_item")):
		throw_pick();
	
	
func _physics_process(delta):
	if(health <= 0):
		velocity.x = 0;
	
	velocity.y += gravity * delta;
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false);
	
	if(health <= 0): return;

	velocity.x = current_speed
	if(velocity.x > max_speed):
		current_speed = max_speed
	elif(velocity.x < -max_speed):
		current_speed = -max_speed;
		
	if(!Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right")):
		current_speed = lerp(current_speed, 0, delta * acceleration);
	if( abs(current_speed) < 3): current_speed = 0
	
	if(jumping):
		velocity.y -= jump_vector
		jump_vector *= jump_dampening
		
	if(is_on_floor() && !land_sound_played):
		$land.play();
		land_sound_played = true;
	
	if(!is_on_floor()):
		land_sound_played = false
	
	
	
func _jump():
	if(jumping || health <= 0): return;
	if(is_on_floor()):
		$jump_sound.play();
		jumping = true;
		jump_vector = jump_force
	pass
	
	
func control_gfx():
	if(attacking || health <= 0): return
	if(Input.is_action_pressed("move_left")):
		$AnimatedSprite.flip_h = true;
		get_node("AttackHitbox/CollisionShape2D").position.x = -4.542
	if(Input.is_action_pressed("move_right")):
		$AnimatedSprite.flip_h = false;
		get_node("AttackHitbox/CollisionShape2D").position.x = 4.542
	
	
	$walkParticles.direction.x = -velocity.x/10;
	if(abs(velocity.x) > 0):
		if($run_sound.playing == false && is_on_floor()):
			$run_sound.playing = true;
		if(has_pick):
			$AnimatedSprite.animation = "run";
		else:
			$AnimatedSprite.animation = "run_noPick";
		if(is_on_floor()):
			$AnimatedSprite.speed_scale = abs(velocity.x/40);
		else:
			$AnimatedSprite.speed_scale = 0;
		if (abs(velocity.x) > 5  && is_on_floor()):
			$walkParticles.emitting = true;
	else:
		if(has_pick):
			$AnimatedSprite.animation = "idle";
		else:
			$AnimatedSprite.animation = "idle_noPick"
		$run_sound.playing = false;
		$AnimatedSprite.speed_scale = 2;
		$walkParticles.emitting = false;
	if(!is_on_floor()):
		$walkParticles.emitting = false;
		$run_sound.playing = false;


func attack():
	if (attacking || !has_pick || health <= 0): return
	$attack_sound.play()
	$AttackHitbox.monitoring = true;
	attacking = true;
	$AnimatedSprite.speed_scale = 2.5;
	$AnimatedSprite.animation = "attack";
	yield($AnimatedSprite, "animation_finished");
	attacking = false;
	$AttackHitbox.monitoring = false;


#for dropping through platforms
func drop():
	if(is_on_floor()):
		position.y += 1;


func _on_AttackHitbox_body_entered(body):
	body.take_damage(attack_damage);
	pass # Replace with function body.


func throw_pick():
	if(!has_pick || (health <= 0)): return;
	$throw_sound.play();
	has_pick = false;
	var pick = pick_path.instance();
	get_tree().get_root().get_node("Main").add_child(pick);
	pick.position = position;
	
	var force: Vector2 = Vector2.ZERO;
	force.y = -15;
	force.x = 120 * toss_dir;
	pick.apply_impulse(Vector2.ZERO, force);
	yield(get_tree().create_timer(.1), "timeout");
	pick.apply_torque_impulse(100 * toss_dir)
	
	pass;


func take_damage(damage: float):
	if(health <= 0): return
	health -= damage;
	$hurt_sound.play();
	$AnimatedSprite.modulate = Color(10,10,10,10);

	if(health <= 0):
		die();
	
	yield(get_tree().create_timer(.1), "timeout");
	$AnimatedSprite.modulate = Color(1,1,1,1)
	
	
func control_oxygen():
	if(GameManager.game_state == GameManager.EXPLORING):
		if(!oxygen_reduction_ready): return;
		oxygen_reduction_ready = false;

		
		yield(get_tree().create_timer(2), "timeout");
		current_oxygen -= 1;
		
		if(current_oxygen <= 0):
			current_oxygen = 0;
			take_damage(1);
			
			
		if(current_oxygen <= 4):
			$LowO2.play();
		
		oxygen_reduction_ready = true;

	if(GameManager.game_state == GameManager.IDLE || GameManager.game_state == GameManager.DRILLING):
		if(!oxygen_refill_ready): return;
		oxygen_refill_ready = false;
		current_oxygen += 1;
		
		if(current_oxygen > oxygen):
			current_oxygen = oxygen;
		
		yield(get_tree().create_timer(.25), "timeout");
		oxygen_refill_ready = true;

	
func die():
	$AnimatedSprite.animation = "Dead"
	$die_sound.play();
	pass




