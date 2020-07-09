extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var picked_up
var holder = null
var pickable = false
var orig_scale

func pick_up(picker):
	# holder = picker
	if picker == holder or holder == null:
		holder = picker
		if picked_up:
			leave()
		else:
			carry()
	elif picker != holder and holder != null:
		leave()
		holder = picker
		carry()

func _process(delta):
	if picked_up:
		if holder.name == "Player":
			set_global_transform(holder.get_node("Armature/Skeleton/CarryPosition").get_global_transform())
		else:
			set_global_transform(holder.get_node("HoldingPosition").get_global_transform())
	if global_transform.origin.y < 1:
		print("Clear item")
		queue_free()

func carry():
	$CollisionShape.set_disabled(true)
	holder.carried_object = self
	self.set_mode(1)
	picked_up = true

func leave():
	$CollisionShape.set_disabled(false)
	holder.carried_object = null
	self.set_mode(0)
	picked_up = false
	holder = null
	self.scale = orig_scale



func throw(power):
	leave()
	apply_impulse(Vector3(), holder.look_vector * Vector3(power, power, power))


# Called when the node enters the scene tree for the first time.
func _ready():
	orig_scale = self.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
