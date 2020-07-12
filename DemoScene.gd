class_name BaseScene

extends Spatial

var finished_count = 0
var players_init = false

func player_selection():
	get_tree().current_scene.get_node("UI/PlayerSelectionNotice").popup_centered()
	get_tree().paused = true

func _ready():
	player_selection()
