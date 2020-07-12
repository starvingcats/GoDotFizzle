extends Control

var player_prefixes = ["", "p2_"]
var instanced_prefixes = []

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

	instanced_prefixes.append(prefix)

func _input(event):

	if !get_tree().current_scene.players_init:

		for prefix in player_prefixes:
			if Input.is_action_just_pressed(prefix + "pause_menu"):
				create_player(prefix)
				get_tree().current_scene.players_init = true
				get_node("PlayerSelectionNotice").hide()
				get_tree().paused = false
	else:

		for prefix in player_prefixes:

			if Input.is_action_just_pressed(prefix + "pause_menu"):

				if !(prefix in instanced_prefixes):
					create_player(prefix)
				else:
					if !get_tree().paused:
						get_tree().current_scene.get_node("UI/Popup").popup_centered()
						get_tree().paused = true
					else:
						get_tree().current_scene.get_node("UI/Popup").hide()
						get_tree().paused = false
