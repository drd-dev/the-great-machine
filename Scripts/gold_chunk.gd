extends RigidBody2D

var pickup_range: float = 10;

var pickup_ready: bool = false;

func _ready():
	yield(get_tree().create_timer(.5), "timeout");
	pickup_ready = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(position.distance_to(GameManager.player.position) <= pickup_range && pickup_ready):
		GameManager.gold_collected += 1
		AudioManager.Gold_Colelcted_SFX();
		queue_free();
