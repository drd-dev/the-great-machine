extends RigidBody2D


var can_pickup: bool = false;
var sound_played: bool = false;

func _ready():
	yield(get_tree().create_timer(.5), "timeout");
	can_pickup = true;



func _process(_delta):
	if(linear_velocity.length() > 25):
		$particles.emitting = true;
	else:
		$particles.emitting = false;
	if(GameManager.player.position.distance_to(position) < 12 && can_pickup):
		GameManager.player.has_pick = true;
		AudioManager.PickUp_Axe_SFX();
		queue_free();
		



func _on_Area2D_body_entered(body):
	$AudioStreamPlayer2D.play();
	if(linear_velocity.length() > 25):
		body.take_damage(2);


func _on_player_pick_body_entered(_body):
	if(!sound_played):
		$AudioStreamPlayer2D.play();
		linear_velocity = Vector2.ZERO;
		angular_velocity = 0
		sound_played = true;
	pass # Replace with function body.
