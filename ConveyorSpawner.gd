extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawn_item(itemname):
	var scene = load("res://" + itemname + ".tscn")
	var item_node = scene.instance()
	var ItemContainer = get_parent().get_node("ConveyorContainer")
	var ItemSpawner = self
	ItemContainer.add_child(item_node)
	item_node.set_translation(ItemSpawner.translation)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
