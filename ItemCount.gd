extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	text = "Item Count: " + str(get_tree().current_scene.get_node("ItemContainer").get_child_count())
