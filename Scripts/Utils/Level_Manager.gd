extends Node


var base_path: String = "res://Levels/"


var loader
var wait_frames
var time_max = 100 #msec
var current_level

func _ready():
	var root = get_tree().get_root();
	current_level = root.get_child(root.get_child_count() - 1)


#called to load a new level
func load_level(name: String):
	loader = ResourceLoader.load_interactive(base_path + name + ".tscn");
	if loader == null: #check for errors
		_show_error();
		return
	set_process(true);
	
	current_level.queue_free() #delete old scene
	
	wait_frames = 1
	
	
	
	
func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			_set_new_scene(resource)
			break
		elif err == OK:
			#update_progress()
			return
		else: # Error during loading.
			_show_error()
			loader = null
			break


func _update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
	get_node("progress").set_progress(progress)

	# ...or update a progress animation?
	var length = get_node("animation").get_current_animation_length()

	# Call this on a paused animation. Use "true" as the second argument to
	# force the animation to update.
	get_node("animation").seek(progress * length, true)


func _set_new_scene(scene_resource):
	current_level = scene_resource.instance()
	get_node("/root").add_child(current_level)
	
	
func _show_error():
	print("LEVEL MANAGER: error loading level..." );
