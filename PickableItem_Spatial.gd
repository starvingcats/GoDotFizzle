extends Spatial

var picked_up
var holder = null
var pickable = false
var orig_scale

func _ready():
	orig_scale = self.scale

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
		if "Player" in holder.name:
			set_global_transform(holder.get_node("Armature/Skeleton/CarryPosition").get_global_transform())
		else:
			set_global_transform(holder.get_node("HoldingPosition").get_global_transform())
	if global_transform.origin.y < 1:
		print("Clear item")
		queue_free()

func carry():
	holder.carried_object = self
	if holder.has_method("add_object"):
		holder.add_object(self)
	# self.set_mode(1)
	picked_up = true

func leave():
	holder.carried_object = null
	# self.set_mode(0)
	picked_up = false
	holder = null
	self.scale = orig_scale

