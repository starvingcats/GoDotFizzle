class_name PickableItem

extends RigidBody

var picked_up
var holder = null
var orig_scale

func _ready():
	orig_scale = self.scale

func pick_up(picker):
	if picker == holder or holder == null:
		holder = picker
		if picked_up:
			leave()
		else:
			carry()
	elif picker != holder and holder != null:  # pick item from other holder
		leave()
		holder = picker
		carry()

func _process(delta):
	if picked_up:
		if "Player" in holder.name:
			set_global_transform(holder.get_node("Armature/Skeleton/CarryPosition").get_global_transform())
		else:
			set_global_transform(holder.get_node("HoldingPosition").get_global_transform())
			var index = holder.carried_objects.find(self)
			translate_object_local(Vector3.UP * index * 0.2)

	if global_transform.origin.y < 1:
		print("Clear item")
		queue_free()

func carry():
	$CollisionShape.set_disabled(true)
	if holder.has_method("add_object"):
		holder.add_object(self)
	else:
		holder.carried_object = self
	self.set_mode(1)
	picked_up = true

func leave():
	picked_up = false
	self.scale = orig_scale
	$CollisionShape.set_disabled(false)
	self.set_mode(0)

	if !holder:
		return

	if !holder.has_method("add_object"):
		holder.carried_object = null
	holder = null

func throw(power):
	leave()
	var zdir = get_global_transform().basis[2]  # z-axis is current player front
	apply_central_impulse(zdir * power + Vector3.UP * power)
