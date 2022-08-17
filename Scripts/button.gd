extends AnimatedSprite

var is_on: bool = false;
var interact_distance = 20;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(GameManager.player != null):
		var distance = position.distance_to(GameManager.player.position);
		if(distance <= interact_distance && GameManager.game_state != GameManager.DRILLING):
			if(Input.is_action_just_pressed("interact")):
				if(!is_on):
					is_on = true;
					get_parent().start_drill();
					frame = 1;
			
	
		if(distance <= interact_distance && GameManager.game_state != GameManager.DRILLING):
			$Label.visible = true;
			$E.visible = true;
		else:
			$Label.visible = false;
			$E.visible = false;

	
	if(GameManager.game_state != GameManager.DRILLING):
		frame = 0;
		is_on = false
		
		
	
