extends Timer

func _on_ConveyorSpawnTimer_timeout():
	var ItemSpawner = get_parent().get_node("ConveyorPath/ConveyorSpawner")
	ItemSpawner.spawn_item("ConveyorSlot")
	
	for conv in get_parent().get_node("ConveyorPath/ConveyorContainer").get_children():
		conv.move_allowed = true

	get_parent().get_node("ConveyorPath/MoveTimer").start()
