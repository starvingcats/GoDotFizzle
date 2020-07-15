extends CoolDownActionSpot

# Generic item spawner script to be used on dispenser bodies
#
# call execute method to spawn item defined in scene given by item_sene_path
# use item_spawner node to define poistion where the item is spawned
# item_random_count_max defines the random number of items spawned
# throw_items adds an impulse to items after spawning in X-direction
# throw_vector gives direction to impulse added

export(String, FILE, "*.tscn") var item_scene_path
export (NodePath) var item_container
export (NodePath) var item_spawner_path
export(int, 1, 10) var item_random_count_max
export(int, "No", "Yes") var throw_items
export(Vector3) var throw_vector

func spawn():
	var scene = load(item_scene_path)
	var item_node = scene.instance()
	get_node(item_container).add_child(item_node)
	item_node.set_global_transform(get_node(item_spawner_path).global_transform)
	return item_node

func execute(player):
	for i in range(randi() % item_random_count_max + 1):
		var node = spawn()
		if throw_items:
			node.apply_central_impulse(Vector3(
				throw_vector.x * randf(),
				throw_vector.y * randf(),
				throw_vector.z * randf()
			))
