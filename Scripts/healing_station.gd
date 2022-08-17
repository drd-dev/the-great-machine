extends Node2D


export var heal_cost: int = 10;
export var health_increase = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(GameManager.player != null):
		var distance = GameManager.player.position.distance_to(position)
		if(distance < 15):
			if(Input.is_action_just_pressed("interact")):
				if(GameManager.gold_collected >= heal_cost && GameManager.player.health < 3):
					GameManager.gold_collected -= heal_cost;
					Heal_Player(health_increase);
					heal_cost += 10;
				else:
					$purchase_fail.play();
					
		
		if(distance <= 15):
			$Label.visible = true;
			$E.visible = true;
			$gold.visible = true;
			$price.visible = true;
			$price.text = String(heal_cost);
		else:
			$Label.visible = false;
			$E.visible = false;
			$gold.visible = false;
			$price.visible = false;



func Heal_Player(amount: float):
	$purchase_success.play();
	if(GameManager.player != null):
		GameManager.player.health += amount;
	pass
