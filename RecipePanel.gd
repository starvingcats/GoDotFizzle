extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var label_container = get_node("GridContainer")
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
				msg += '\n --> ' + item.get_state().get_node_name(0)
		new_label.text = msg
		label_container.add_child(new_label)
