extends Node2D



func start_death_timer():
	yield(get_tree().create_timer(6), "timeout");
	queue_free();
