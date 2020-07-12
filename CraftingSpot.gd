class_name CraftingSpot

extends Spatial

export(PackedScene) var recipe_scene

var can_craft = false
var crafting = false
var crafting_player = null
var recipe_item_node = null
var carried_objects = []


func _ready():
	creat_recipe_node()
	$CraftingTimer.wait_time = recipe_item_node.recipe_time

func creat_recipe_node():
	recipe_item_node = recipe_scene.instance()

func add_object(object):
	carried_objects.append(object)
	can_craft = recipe_item_node.check_objects(carried_objects)

func craft(player):
	crafting_player = player
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
	crafting = false
	for item in carried_objects:
		item.queue_free()
	carried_objects = []

	var ItemContainer = get_node("HoldingPosition")
	var ItemSpawner = ItemContainer
	ItemContainer.add_child(recipe_item_node)
	recipe_item_node.set_translation(ItemSpawner.translation)
	recipe_item_node.pick_up(self)
	crafting_player.get_node("CraftIndicator").visible = false
	crafting_player = null
