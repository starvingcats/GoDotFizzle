extends Position3D

func spawn_item(itemname):
	var scene = load("res://" + itemname + ".tscn")
	var item_node = scene.instance()
	var ItemContainer = get_parent().get_node("ItemContainer")
	var ItemSpawner = get_parent().get_node("ItemSpawner")
	ItemContainer.add_child(item_node)
	item_node.set_translation(ItemSpawner.translation)
