extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawn_item(itemname):
	var scene = load("res://" + itemname + ".tscn")
	var item_node = scene.instance()
	var ItemContainer = get_parent().get_node("ItemContainer")
	var ItemSpawner = get_node("ScrewSpawn")
	ItemContainer.add_child(item_node)
	#item_node.set_translation(ItemSpawner.translation)
	item_node.set_global_transform(ItemSpawner.global_transform)
	return item_node

func execute():
	print("spawn!")
	for i in range(randi() % 4 + 1):
		var node = spawn_item("Screw")
		node.apply_central_impulse(Vector3(10 * randf(), randf(), randf()))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
