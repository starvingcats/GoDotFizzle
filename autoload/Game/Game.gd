extends Node2D

signal SceneIsLoaded

enum {IDLE, FADEOUT, FADEIN}

onready var CurrentScene = null
var NextScene
var FadeState:int = IDLE

var player_prefixes = ["p1_", "p2_"]

var registered_player_prefixes = ["p1_"]

var instanced_prefixes = []
var player_instance_paths = []

var level_finished = false

var m_db_man = null
var db = null

func _ready()->void:
	MenuEvent.connect("Options",	self, "on_Options")
	Event.connect("Exit",		self, "on_Exit")
	Event.connect("ChangeScene",self, "on_ChangeScene")
	Event.connect("Restart", 	self, "restart_scene")
	#Background async loader
	SceneLoader.connect("scene_loaded", self, "on_scene_loaded")
	GuiBrain.gui_collect_focusgroup()

	Event.connect("LevelFinished", 	self, "on_level_finished")
	init_db()

func on_ChangeScene(scene)->void:
	registered_player_prefixes = []
	for index in range(Settings.PlayerCount):
		registered_player_prefixes.append(player_prefixes[index])
	if FadeState != IDLE:
		return
	if Settings.HTML5:
		NextScene = load(scene)
	else:
		SceneLoader.load_scene(scene, {scene="Level"})
	FadeState = FADEOUT
	$FadeLayer/FadeTween.interpolate_property($FadeLayer, "percent", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)
	$FadeLayer/FadeTween.start()

func on_Exit()->void:
	if FadeState != IDLE:
		return
	get_tree().quit()

func on_scene_loaded(Loaded)->void:
	NextScene = Loaded.resource
	emit_signal("SceneIsLoaded")	#Scene fade signal in case it loads longer than fade out

func change_scene()->void: #handle actual scene change
	if NextScene == null:
		return
	print("change_scene: ", NextScene) #ERROR InputMouseButton something
	CurrentScene = NextScene
	NextScene = null
	get_tree().change_scene_to(CurrentScene)

func restart_scene()->void:
	if FadeState != IDLE:
		return
	get_tree().reload_current_scene()

func on_level_finished(scene):

	var scores_table = db.get_table_by_name("Scores")
	scores_table.add_row([scene.total_score])
	db.save_db()

	level_finished = true
	$PauseLayer/Control/MarginContainer/VBoxContainer/ScoreContainer/ScoreNum.text = str(scene.total_score)
	MenuEvent.Paused = true

func _on_FadeTween_tween_completed(object, key)->void:
	match FadeState:
		IDLE:
			pass
		FADEOUT:
			if NextScene == null:
				print("Not loaded, please wait!")
				yield(self, "SceneIsLoaded")
			change_scene()
			FadeState = FADEIN
			$FadeLayer/FadeTween.interpolate_property($FadeLayer, "percent", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)
			$FadeLayer/FadeTween.start()
		FADEIN:
			FadeState = IDLE

func init_db():
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
