extends StaticBody2D


var open_distance: float = 30;
var is_open = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(GameManager.player != null):
		var distance = position.distance_to(GameManager.player.position);
		if(distance <= open_distance && GameManager.game_state != GameManager.DRILLING):
			open_door();
		elif(is_open):
			close_door();

func open_door():
	if(is_open): return;
	is_open = true;
	$CollisionShape2D.disabled = true;
	$gfx.play("open", false);
	$open.play();
	pass
	
func close_door():
	if(!is_open): return;
	is_open = false;
	$CollisionShape2D.disabled = false;
	$close.play();
	$gfx.play("open", true);
