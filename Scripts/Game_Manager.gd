extends Node


var gold_collected = 0;


var player = null;
enum { DRILLING, EXPLORING, IDLE, MENU }
var game_state = MENU;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
