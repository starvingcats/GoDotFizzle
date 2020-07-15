extends Label

func _process(delta):
	text = "Item Count: " + str(get_tree().current_scene.get_node("ItemContainer").get_child_count())
