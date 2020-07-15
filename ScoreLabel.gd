extends Label

func _process(delta):
	text = "Score: " + str(get_tree().current_scene.total_score)
