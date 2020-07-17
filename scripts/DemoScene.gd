class_name BaseScene

extends Spatial

var finished_count = 0
var players_init = false
var total_score = 0.0
var cur_multiplier = 1.0
var game_over = false
var m_db_man = null
var db = null

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

	m_db_man = load(gddb_constants.c_addon_main_path + "core/db_man.gd").new()

	var file = File.new()
	var error = file.open("user://saves.json", File.READ)
	file.close()
	if error == OK:
		print("User db found, using ...")
		var res = m_db_man.load_database("user://saves.json")
		db = m_db_man.get_db_by_id(res)
	else:
		print("Error opening file!")
		print("Database not found in user directory, creating ...")
		var db_schema = m_db_man.load_database("res://fizzle_db.json")
		if db_schema < 0:
			print("Schema not found, aborting ...")
			return
		else:
			db = m_db_man.get_db_by_id(db_schema)
			db.set_db_filepath("user://saves.json")
			print("DB filepath set, saving ...")
			db.set_db_name("Scores")
			db.save_db()
			print("DB created")

func _on_LevelTimer_timeout():
	game_over = true
	var score_label = get_tree().current_scene.get_node("UI/GameOverNote/GridContainer/ScoreLabel")
	score_label.text = "Your Score: " + str(total_score)
	var scores_table = db.get_table_by_name("Scores")
	scores_table.add_row([total_score])
	db.save_db()
	get_tree().current_scene.get_node("UI/GameOverNote").popup_centered()
	get_tree().paused = true
