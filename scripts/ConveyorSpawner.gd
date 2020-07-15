extends Position3D

func spawn_item(itemname):
	var scene = load("res://" + itemname + ".tscn")
	var item_node = scene.instance()
	var ItemContainer = get_parent().get_node("ConveyorContainer")
	var ItemSpawner = self
	ItemContainer.add_child(item_node)
	item_node.set_translation(ItemSpawner.translation)

func _on_MoveTimer_timeout():
	for conv in get_parent().get_node("ConveyorContainer").get_children():
		conv.move_allowed = false
