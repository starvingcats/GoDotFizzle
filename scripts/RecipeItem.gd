class_name RecipeItem

extends PickableItem

export(Array, PackedScene) var recipe_scenes
export(PackedScene) var recipe_tool
export(int) var recipe_time

export(int, "No", "Yes") var scored_recipe
export(int) var basic_score

func check_objects(objects):

	var recipe_itemnames = []
	for item in recipe_scenes:
		var item_name = item.get_state().get_node_name(0)
		recipe_itemnames.append(item_name)

	if objects.size() != recipe_itemnames.size():
		print("No size match early exit!")
		return false
	var recipe_match = true
	for index in range(objects.size()):
		var objectname = objects[index].name
		var recipe_item_name = recipe_itemnames[index]
		print(objectname, recipe_item_name)
		recipe_match = recipe_item_name in objectname
	print(recipe_match)
	return recipe_match
