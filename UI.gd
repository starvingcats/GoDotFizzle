extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):

	if Input.is_action_just_pressed("pause_menu"):
		if !get_tree().current_scene.players_init:
			return
		if !get_tree().paused:
			get_tree().current_scene.get_node("UI/Popup").popup_centered()
			get_tree().paused = true
		else:
			get_tree().current_scene.get_node("UI/Popup").hide()
			get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
