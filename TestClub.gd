extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var picked_up
var holder
var pickable = false
var orig_scale

func pick_up(player):
	holder = player

	if picked_up:
		leave()
	else:
		carry()

func _process(delta):
	if picked_up:
		set_global_transform(holder.get_node("Armature/Skeleton/CarryPosition").get_global_transform())
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
