extends Label

func _process(delta):
	text = "Finished Count: " + str(get_tree().current_scene.finished_count)
