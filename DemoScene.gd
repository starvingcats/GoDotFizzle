extends Spatial

var finished_count = 0
var players_init = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func player_selection():
	get_tree().current_scene.get_node("UI/PlayerSelectionNotice").popup_centered()
	get_tree().paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# player_selection()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
