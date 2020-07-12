extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pressable = true

func execute():
	if pressable == true:
		pressable = false
		get_node("Timer").start()
		print("Pressed!")
		get_parent().get_node("ItemSpawner").spawn_item("WoodBlock")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	pressable = true
