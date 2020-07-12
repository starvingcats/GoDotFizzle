extends KinematicBody

export(PackedScene) var recipe_scene

var recipe_item_node = null

var move_speed = 5
var move_treshold = 5
var move_time = 0.4

var patrol_path
var patrol_points
var patrol_index = 0
var carried_object = null
var carried_objects = []

var cur_move = 0

var recipe_done = false

var can_craft = false
var crafting = false

var crafting_player = null

func _ready():
	patrol_path = get_parent().get_parent()
	patrol_points = patrol_path.curve.get_baked_points()

	recipe_item_node = recipe_scene.instance()
	$RecipeTimer.wait_time = recipe_item_node.recipe_time

func add_object(object):
	carried_objects.append(object)
	can_craft = recipe_item_node.check_objects(carried_objects)

func craft(player):
	crafting_player = player
	if crafting == false and recipe_done == false:
		print("Crafting...")
		crafting_player.get_node("CraftIndicator").visible = true
		crafting = true
		$RecipeTimer.start()

func abort_craft():
	if crafting == true:
		print("Aborting crafting...")
		crafting = false
		$RecipeTimer.stop()
		crafting_player.get_node("CraftIndicator").visible = false
		crafting_player = null

func die():
	for item in carried_objects:
		print(item)
		item.leave()
		if "WoodChest" in item.name:
			get_tree().current_scene.finished_count += 1
			print("FISNISHED!")
	queue_free()

func run_path(delta):
	if !patrol_path:
		return
	cur_move += delta
	if cur_move < move_treshold:
		return
	if cur_move > move_treshold + move_time:
		cur_move = 0
		return
	var target = patrol_points[patrol_index]
	var position = transform.origin
	if position.distance_to(target) < 1 and patrol_index == patrol_points.size() - 1:
		die()
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	var velocity = (target - position).normalized() * move_speed
	velocity = move_and_slide(velocity)

func transfer(item):
	pass

func _physics_process(delta):
	run_path(delta)

func _on_RecipeTimer_timeout():
	print("recipe done!")
	recipe_done = true
	crafting = false
	for item in carried_objects:
		item.queue_free()
	carried_objects = []

	var ItemContainer = get_node("HoldingPosition")
	var ItemSpawner = ItemContainer
	ItemContainer.add_child(recipe_item_node)
	recipe_item_node.set_translation(ItemSpawner.translation)
	recipe_item_node.pick_up(self)
	crafting_player.get_node("CraftIndicator").visible = false
	crafting_player = null
	# add_object(item_node)

