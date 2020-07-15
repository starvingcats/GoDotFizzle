extends Label

func _process(delta):
	text = "Time left: " + str(get_tree().current_scene.get_node("LevelTimer").time_left) + " s"
