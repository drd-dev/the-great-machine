extends CanvasModulate


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var state = GameManager.game_state;
	
	if(state == GameManager.EXPLORING):
		Light_Blue_Tint();
	else:
		Clear_Tint();


func Light_Blue_Tint():
	color = Color("#bfe4ff")
	

func Blue_Tint():
	color = Color.blue;
	
func Red_Tint():
	color = Color.red;
	
func Clear_Tint():
	color = Color.white;
