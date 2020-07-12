extends Timer

func _on_ConveyorSpawnTimer_timeout():
	var ItemSpawner = get_parent().get_node("ConveyorPath/ConveyorSpawner")
	ItemSpawner.spawn_item("ConveyorSlot")
