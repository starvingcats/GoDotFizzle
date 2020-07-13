class_name ConveyorSlot

extends CraftingSpot

var move_speed = 5
var move_treshold = 5
var move_time = 0.4

var patrol_path
var patrol_points
var patrol_index = 0

var cur_move = 0

var has_scored = false
var base_scene


func _ready():
	patrol_path = get_parent().get_parent()
	patrol_points = patrol_path.curve.get_baked_points()
	base_scene = get_tree().current_scene

func die():
	for item in carried_objects:
		assert(item != null)
		check_score(item)
		item.leave()

	if !has_scored:
		base_scene.sub_multiplier()

	queue_free()

func check_score(item):
	if item.has_method("check_objects") and item.scored_recipe:
		base_scene.finished_count += 1
		base_scene.calc_score(item.basic_score)
		base_scene.add_multiplier()
		has_scored = true
		print("FISNISHED!")

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
	var move_fnc = funcref(self, "move_and_slide")
	if move_fnc:
		velocity = move_fnc.call_func(velocity)

func _physics_process(delta):
	run_path(delta)

func _on_RecipeTimer_timeout():
	_on_CraftingTimer_timeout()


