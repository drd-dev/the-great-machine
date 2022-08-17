extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(GameManager.player != null):
		var distance = GameManager.player.position.distance_to(position)
		if(distance < 15):
			if(Input.is_action_just_pressed("interact")):
					GameManager.player.has_pick = true;
					AudioManager.Button_SFX();
					
		
		if(distance <= 15):
			$Label.visible = true;
			$E.visible = true;
		else:
			$Label.visible = false;
			$E.visible = false;
