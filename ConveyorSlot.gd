extends KinematicBody

var move_speed = 1.5
var patrol_path
var patrol_points
var patrol_index = 0
var carried_object = null

func _ready():
	patrol_path = get_tree().current_scene.get_node("ConveyorPath")
	patrol_points = patrol_path.curve.get_baked_points()

func die():
	if carried_object != null and carried_object.has_method("leave"):
		carried_object.leave()		
	queue_free()

func run_path():
	if !patrol_path:
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
	run_path()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
