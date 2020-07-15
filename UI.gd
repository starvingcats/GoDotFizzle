extends Control

var player_prefixes = ["", "p2_"]
var instanced_prefixes = []
var player_instance_paths = []

func create_player(prefix):
	if prefix in instanced_prefixes:
		return

	var scene = load("res://player/player.tscn")
	var item_node = scene.instance()
	var ItemContainer = get_parent()
	var ItemSpawner = get_parent().get_node("PlayerSpawn")
	ItemContainer.add_child(item_node)
	item_node.set_translation(ItemSpawner.translation)

	item_node.player_prefix = prefix
	item_node.rotate_y(-PI/2)
	player_instance_paths.append(item_node.get_path())

	instanced_prefixes.append(prefix)

func _process(delta):
	var player_panel_container = get_node("PlayerPanel/HBoxContainer")
	for item in player_panel_container.get_children():
		item.queue_free()

	for player_path in player_instance_paths:
		var player_node = get_node(player_path)
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

func _ready():
	var action_events = InputMap.get_actions()
	for action in action_events:
		var input_events = InputMap.get_action_list(action)
		for event in input_events:
			# print(event.as_text())
			pass

func _input(event):

	if !get_tree().current_scene.players_init:

		for prefix in player_prefixes:
			if Input.is_action_just_pressed(prefix + "pause_menu"):
				create_player(prefix)
				get_tree().current_scene.players_init = true
				get_node("PlayerSelectionNotice").hide()
				get_tree().paused = false
	else:

		if get_tree().current_scene.game_over:
			return

		for prefix in player_prefixes:

			if Input.is_action_just_pressed(prefix + "pause_menu"):

				if !(prefix in instanced_prefixes):
					create_player(prefix)
				else:
					if !get_tree().paused:
						get_tree().current_scene.get_node("UI/PausePopup").popup_centered()
						get_tree().paused = true
					else:
						get_tree().current_scene.get_node("UI/PausePopup").hide()
						get_tree().paused = false
