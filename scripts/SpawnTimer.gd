extends Timer

func _on_SpawnTimer_timeout():
	var ItemSpawner = get_parent().get_node("ItemSpawner")
	ItemSpawner.spawn_item("WoodBlock")
