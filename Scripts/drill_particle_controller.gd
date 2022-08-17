extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(GameManager.game_state == GameManager.DRILLING):
		set_particle_state(true)
	else:
		set_particle_state(false)


func set_particle_state(state: bool):
	$rocks.emitting = state;
	$rocks2.emitting = state;
	$rocks3.emitting = state;
	$dust_L.emitting = state;
	$dust_R.emitting = state;
