extends Node

#onready var hp: = $CanvasLayer/Control/MarginContainer/VBoxContainer/Top/HP
#onready var score: = $CanvasLayer/Control/MarginContainer/VBoxContainer/Top/Score
onready var gui: = $CanvasLayer/GUI

var visible: = false setget set_visible

func _ready()->void:
	gui.visible = visible

func set_visible(value: bool)->void:
	visible = value
	gui.visible = value

func fill_playerpanel():

	var player_panel_container = get_node("CanvasLayer/GUI/PlayerPanel/HBoxContainer")

	for item in player_panel_container.get_children():
		item.queue_free()

	for player_path in Game.player_instance_paths:
		var player_node = get_node(player_path)
		if !player_node:
			continue
		var player_msg = '# ' + player_node.name
		if player_node.carried_object:
			player_msg += 'Holding Item: '
			player_msg += player_node.carried_object.name
		if player_node.transfer_slot:
			player_msg += ' Facing CraftingSpot: '
			player_msg += player_node.transfer_slot.name
			player_msg += ' (' + player_node.transfer_slot.recipe_item_node.name + ')'
			if player_node.transfer_slot.can_craft:
				player_msg += ' (READY)'
		if player_node.pickitem:
			player_msg += ' Can pick up item: '
			player_msg += player_node.pickitem.name
		if player_node.interact_object:
			player_msg += ' Can interact with: '
			player_msg += player_node.interact_object.name
		var player_label = Label.new()
		player_label.text = player_msg
		player_panel_container.add_child(player_label)

func fill_recipepanel():

	var label_container = get_node("CanvasLayer/GUI/RecipePanel/ScrollContainer/GridContainer")

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

func fill_scoreplanel():

	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/ScoreLabel").text = "Score: " + str(get_tree().current_scene.total_score)
	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/ConveyorCount").text = "Conveyor Count: " + str(get_tree().current_scene.get_node("ConveyorPath/ConveyorContainer").get_child_count())
	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/FinishedCount").text = "Finished Count: " + str(get_tree().current_scene.finished_count)
	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/ItemCount").text = "Item Count: " + str(get_tree().current_scene.get_node("ItemContainer").get_child_count())
	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/ComboBonus").text = "Combo x: " + str(get_tree().current_scene.cur_multiplier)
	get_node("CanvasLayer/GUI/ScorePanel/GridContainer/LevelTime").text = "Time left: " + str(get_tree().current_scene.get_node("LevelTimer").time_left) + " s"


func _process(delta):
	if visible:
		fill_playerpanel()
		fill_recipepanel()
		fill_scoreplanel()
