extends KinematicBody2D


export var move_speed: float = 5;
export var attack_damage: float = 1;
export var attack_range: float = 15;
export var health: float = 2;
enum {IDLE, ATTACKING, MOVING, DYING}

var current_state = MOVING;


#movement
var direction = 1;
var velocity = Vector2.ZERO;


var attack_ready: bool = true;
var attack_cooldown = 1;
var sound_played = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	walk_sound();
	if(current_state == IDLE):
		return;
	elif(current_state == ATTACKING):
		attack()
	elif(current_state == MOVING):
		move(delta);
		
	if(GameManager.player != null):
		var distance = position.distance_to(GameManager.player.position);
		if(distance <= attack_range):
			current_state = ATTACKING
		
		
	velocity.y += 500 * delta;
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false);



func move(_delta):
	velocity.x = (direction * move_speed);
	if(direction < 0):
		$gfx.flip_h = true;
	else:
		$gfx.flip_h = false;

	
	pass
	
	
func attack():
	if(!attack_ready): return
	attack_ready = false;
	GameManager.player.take_damage(attack_damage);

	#attack cooldown
	yield(get_tree().create_timer(attack_cooldown), "timeout");
	current_state = MOVING;
	attack_ready = true;
	pass
	
	
func take_damage(damage: float):
	health -= damage;
	$gfx.modulate = Color(10,10,10,10);
	$Hit.play();
	if(health <= 0):
		die();
	
	yield(get_tree().create_timer(.1), "timeout");
	$gfx.modulate = Color(1,1,1,1)


func die():
	AudioManager.Slime_killed_SFX();
	queue_free()
	

func walk_sound():
	if(sound_played): return;
	sound_played = true;
	$Walk.play();
	yield(get_tree().create_timer(1), "timeout");
	sound_played = false;
