extends KinematicBody

var move_speed = 5
var patrol_path
var patrol_points
var patrol_index = 0
var carried_object = null
var carried_objects = []

var move_treshold = 5
var move_time = 0.4
var cur_move = 0

var recipe = ''

var recipe_count = 2
var recipe_done = false

var can_craft = false
var crafting = false

func add_object(object):
	carried_objects.append(object)
	print(carried_objects)
	print(object.name)
	var woodplank_count = 0
	for item in carried_objects:
		if "Woodplank" in item.name:
			woodplank_count += 1
	if woodplank_count == recipe_count:
		can_craft = true
		print("YAY can craft")

func craft():
	if crafting == false and recipe_done == false:
		print("Crafting...")
		crafting = true
		get_node("RecipeTimer").start()

func abort_craft():
	if crafting == true:
		print("Aborting crafting...")
		crafting = false
		get_node("RecipeTimer").stop()

func _ready():
	patrol_path = get_parent().get_parent()
	patrol_points = patrol_path.curve.get_baked_points()

func die():
	#if carried_object != null and carried_object.has_method("leave"):
	#		carried_object.leave()
	print(carried_objects)
	for item in carried_objects:
		print(item)
		item.leave()
		if "kiste" in item.name:
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RecipeTimer_timeout():
	print("recipe done!")
	recipe_done = true
	crafting = false
	for item in carried_objects:
		item.queue_free()
	carried_objects = []
	var itemname = "kisteFBX"
	var scene = load("res://" + itemname + ".tscn")
	var item_node = scene.instance()
	var ItemContainer = get_node("HoldingPosition")
	var ItemSpawner = ItemContainer
	ItemContainer.add_child(item_node)
	item_node.set_translation(ItemSpawner.translation)
	item_node.pick_up(self)
	# add_object(item_node)

