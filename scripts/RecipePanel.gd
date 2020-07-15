extends Panel

func _process(delta):
	var label_container = get_node("ScrollContainer/GridContainer")
	for item in label_container.get_children():
		item.queue_free()
	
	var conveyor_container = get_tree().current_scene.get_node("ConveyorPath/ConveyorContainer")
	var conveyors = conveyor_container.get_children()
	for conveyor in conveyors:
		var new_label = Label.new()
		var recipe_name = conveyor.recipe_scene.get_state().get_node_name(0)
		var msg = ''
		if conveyor.blocked:
			msg = "Done: " + recipe_name
		else:
			msg = recipe_name + ':'
			for item in conveyor.recipe_item_node.recipe_scenes:
				var inst = item.instance()
				msg += '\n --> ' + inst.name
				if inst.has_method("check_objects"):
					for sub_scene in inst.recipe_scenes:
						msg += '\n ----> ' + sub_scene.get_state().get_node_name(0)
				inst.queue_free()

		new_label.text = msg
		label_container.add_child(new_label)
