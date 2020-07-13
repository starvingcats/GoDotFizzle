class_name BaseScene

extends Spatial

var finished_count = 0
var players_init = false
var total_score = 0.0
var cur_multiplier = 1.0
var game_over = false

func add_multiplier(add=0.5):
	cur_multiplier += add

func sub_multiplier(sub=0.2):
	cur_multiplier -= sub
	if cur_multiplier < 1.0:
		cur_multiplier = 1.0

func calc_score(recipe_score):
	total_score += recipe_score * cur_multiplier

func player_selection():
	get_tree().current_scene.get_node("UI/PlayerSelectionNotice").popup_centered()
	get_tree().paused = true

func _ready():
	player_selection()

func _on_LevelTimer_timeout():
	game_over = true
	var score_label = get_tree().current_scene.get_node("UI/GameOverNote/GridContainer/ScoreLabel")
	score_label.text = "Your Score: " + str(total_score)
	get_tree().current_scene.get_node("UI/GameOverNote").popup_centered()
	get_tree().paused = true
