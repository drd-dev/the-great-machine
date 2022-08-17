extends Node2D


var fuel: float = 100
var health: float = 100

#drilling
var drill_time: float = 5; #seconds the drill runs for before encountering another cave


#helper
var moving: bool = false;
var cave_target_pos = Vector2.ZERO;
var scroll_speed: float = 2;
var music_changed: bool = false;
var rng = RandomNumberGenerator.new()
var depth = 0;
var tv_depth = 0;

#caves
var caves = [
				preload("res://Levels/caves/Cave_1.tscn"),
				preload("res://Levels/caves/Cave_2.tscn"),
				preload("res://Levels/caves/Cave_3.tscn"),
				preload("res://Levels/caves/Cave_4.tscn"),
				preload("res://Levels/caves/Cave_5.tscn"),
				preload("res://Levels/caves/Cave_6.tscn"),
				preload("res://Levels/caves/Cave_7.tscn"),
				preload("res://Levels/caves/Cave_8.tscn"),
				preload("res://Levels/caves/Cave_9.tscn")
			];
var spawned_cave = null

# Called when the node enters the scene tree for the first time.
func _ready():
	start_drill();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(tv_depth < depth):
		tv_depth += 100 * delta;
		var d = int(round(tv_depth));
		if(d >= depth):
			tv_depth = depth;
			d = depth;
		get_node("tv/count").text = String(d) + " M";

	#move the cave up til we get to the target pos
	if(spawned_cave != null):
		spawned_cave.position = lerp(spawned_cave.position, cave_target_pos, scroll_speed * delta);
		if(scroll_speed < 2):
			scroll_speed += 0.25 * delta;

func start_drill():
	if(GameManager.game_state == GameManager.DRILLING): return;
	depth += 1000;
	music_changed = false;
	cave_target_pos = Vector2(0, -2000);
	$digParticles.set_particle_state(true);
	scroll_speed = 0;
	GameManager.game_state = GameManager.DRILLING;
	AudioManager.Drill_SFX();
	AudioManager.Update_Music();
	$airlock_light_L.color = Color.red;
	$airlock_light_R.color = Color.red;
	
	

	
	if(spawned_cave):
		spawned_cave.get_node("cave_tiles").set_collision_mask_bit(0, false);
		spawned_cave.get_node("cave_tiles").set_collision_layer_bit(0, false);
		spawned_cave.start_death_timer();
	
	
	yield(get_tree().create_timer(drill_time), "timeout");
	stop_drill();



func stop_drill():
	#spawn cave
	cave_target_pos = Vector2.ZERO
	var index = rng.randf_range(0, caves.size());
	spawned_cave = caves[index].instance();
	get_tree().get_root().get_node("Main").add_child(spawned_cave);
	spawned_cave.z_index = -101
	spawned_cave.position = Vector2(0, 1000);
	yield(get_tree().create_timer(4.0), "timeout");
	GameManager.game_state = GameManager.IDLE;
	$airlock_light_L.color = Color.green;
	$airlock_light_R.color = Color.green;
	AudioManager.AirLock_Ready_SFX();
	$digParticles.set_particle_state(false);
	


func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
		if(GameManager.game_state != GameManager.IDLE && GameManager.game_state != GameManager.DRILLING):
			GameManager.game_state = GameManager.IDLE;


func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		if(GameManager.game_state != GameManager.EXPLORING && GameManager.game_state != GameManager.DRILLING):
			GameManager.game_state = GameManager.EXPLORING;
			if(!music_changed):
				AudioManager.Update_Music();
				music_changed = true;



