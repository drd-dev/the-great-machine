extends KinematicBody2D


var health:float = 3;
var gold_to_spawn = 5;


var gold_path = preload("res://Scenes/collectables/gold_chunk.tscn");
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize();

func take_damage(damage: float):
	health -= damage;
	$hurt_sound.play();
	$gold_parts.emitting = true;
	$rock_parts.emitting = true;
	$gfx.modulate = Color(10,10,10,10);

	if(health <= 0):
		die();
	
	yield(get_tree().create_timer(.1), "timeout");
	$gfx.modulate = Color(1,1,1,1)

func die():
	
	for n in range(gold_to_spawn):
		var gold = gold_path.instance();
		get_parent().add_child(gold);
		AudioManager.Rock_Destroyed_SFX();
		var gold_spawn_pos = position;
		gold_spawn_pos.x += rng.randf_range(-.5,.5)
		gold_spawn_pos.y -= .5
		gold.position = gold_spawn_pos
		
		gold.apply_impulse(Vector2.ZERO, (gold.position- position).normalized() * 45)
	
	queue_free()
	pass
