extends Camera2D

export(NodePath) var player;

export var followSpeed: float = 10;




var shake_amount: float = 0;
var playerTarget: KinematicBody2D;
var robotTarget: KinematicBody2D;


# Called when the node enters the scene tree for the first time.
func _ready():
	#GameManager.camera = self;
	playerTarget = get_node(player);


func _process(_delta):
	set_offset(Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount \
	))
	
	if(GameManager.game_state == GameManager.DRILLING):
		set_screen_shake(0.8);
	else:
		set_screen_shake(0);

func _physics_process(_delta):
	position = playerTarget.position;


func screen_shake(amount, duration):
	shake_amount = amount;
	yield(get_tree().create_timer(duration), "timeout");
	shake_amount = 0;
	pass
	
func set_screen_shake(amount):
	shake_amount = amount;
