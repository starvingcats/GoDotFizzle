class_name BaseScene

extends Spatial

var has_players = true

var finished_count = 0
var total_score = 0.0
var cur_multiplier = 1.0

func create_players():

	var player_scene = load("res://player/player.tscn")
	var ItemSpawner = get_node("PlayerSpawn")
	var ItemContainer = self

	Game.player_instance_paths = []
	Game.instanced_prefixes = []

	for prefix in Game.registered_player_prefixes:

		var item_node = player_scene.instance()
		ItemContainer.add_child(item_node)
		item_node.set_translation(ItemSpawner.translation)

		item_node.player_prefix = prefix
		item_node.rotate_y(-PI/2)
		item_node.translate(Vector3.UP * randf())
	
		Game.player_instance_paths.append(item_node.get_path())
		Game.instanced_prefixes.append(prefix)

func add_multiplier(add=0.5):
	cur_multiplier += add

func sub_multiplier(sub=0.2):
	cur_multiplier -= sub
	if cur_multiplier < 1.0:
		cur_multiplier = 1.0

func calc_score(recipe_score):
	total_score += recipe_score * cur_multiplier

func _ready():

	Game.level_finished = false
	create_players()
	Hud.visible = true

func _on_LevelTimer_timeout():
	Event.emit_signal("LevelFinished", self)
