class_name CraftingSpot

extends Spatial

export(PackedScene) var recipe_scene
export(int) var broken_time = 1

var can_craft = false
var crafting = false
var crafting_player = null
var recipe_item_node = null
var carried_objects = []
var blocked = false

onready var effect_node = find_node("SmokeEffect")

func _ready():
	create_recipe_node()
	$CraftingTimer.wait_time = recipe_item_node.recipe_time
	$HoldingPosition/CatchZone.connect("body_entered", self, "_on_CatchZone_body_entered")
	$CraftingTimer.connect("timeout", self, "_on_CraftingTimer_timeout")
	$ResetTimer.wait_time = broken_time
	$ResetTimer.connect("timeout", self, "_on_ResetTimer_timeout")

func break_spot():
	blocked = true
	$ResetTimer.start()
	effect_node.visible = true

func _on_ResetTimer_timeout():
	blocked = false
	effect_node.visible = false

func _on_CatchZone_body_entered(body):
	if body.has_method("pick_up") and body.holder == null:
		body.pick_up(self)

func create_recipe_node():
	recipe_item_node = recipe_scene.instance()

func add_object(object):
	carried_objects.append(object)
	can_craft = recipe_item_node.check_objects(carried_objects)

func craft(player):
	crafting_player = player

	if recipe_item_node.recipe_tool != null:
		if !player.carried_object:
			return
		var player_tool_name = player.carried_object.name
		var recipe_tool_name = recipe_item_node.recipe_tool.get_state().get_node_name(0)

		if !(recipe_tool_name in player_tool_name):
			return

	if crafting == false:
		print("Crafting...")
		crafting_player.get_node("CraftIndicator").visible = true
		crafting = true
		$CraftingTimer.start()

func abort_craft():
	if crafting == true:
		print("Aborting crafting...")
		crafting = false
		$CraftingTimer.stop()
		crafting_player.get_node("CraftIndicator").visible = false
		crafting_player = null

func _on_CraftingTimer_timeout():
	print("Crafting done")
	print(carried_objects)
	crafting = false
	for item in carried_objects:
		item.queue_free()
	carried_objects = []

	var ItemContainer = get_tree().current_scene.get_node("ItemContainer")
	var ItemSpawner = get_node("HoldingPosition")
	ItemContainer.add_child(recipe_item_node)
	recipe_item_node.set_translation(ItemSpawner.translation)
	recipe_item_node.pick_up(self)
	crafting_player.get_node("CraftIndicator").visible = false
	crafting_player = null
	create_recipe_node()
