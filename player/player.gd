extends KinematicBody

const ANIM_FLOOR = 0
const ANIM_AIR = 1

const SHOOT_TIME = 1.5
const SHOOT_SCALE = 2
const CHAR_SCALE = Vector3(0.3, 0.3, 0.3)
const TURN_SPEED = 30

var movement_dir = Vector3()
var linear_velocity = Vector3()

var jumping = false

var air_idle_deaccel = false

var movement_profiles = {
	'normal': {
		'accel': 5.0,
		'deaccel': 14.0,
		'sharp_turn_threshold': 140,
		'max_speed': 5,
		'throw_power': 6,
	},
	'powerup': {
		'accel': 12.0,
		'deaccel': 30.0,
		'sharp_turn_threshold': 180,
		'max_speed': 10,
		'throw_power': 12,
	},
}
var cur_movement = 'normal'

var prev_shoot = false
var shoot_blend = 0

var carried_object = null
var pickitem = null

var transfer_slot = null
var player_prefix = ''

var press_button = null
var press_dispenser = null

var interact_object = null

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

func _ready():
	get_node("AnimationTree").set_active(true)

func _input(event):

	if Input.is_action_just_pressed("debug_reset"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("test_action"):
		print("test_action")

	if Input.is_action_just_pressed(player_prefix + "throw"):
		throw_item()

	if Input.is_action_just_pressed(player_prefix + "craft"):
		if transfer_slot != null and transfer_slot.can_craft == true:
			transfer_slot.craft(self)
		elif interact_object != null:
			interact_object.action(self)

	if Input.is_action_just_pressed(player_prefix + "pick_up"):
		if pickitem != null and carried_object == null:
			pickitem.pick_up(self)
			carried_object = pickitem
			print("Picked up!")
		elif carried_object != null and transfer_slot == null:
			carried_object.pick_up(self)
			carried_object = null
		elif carried_object != null and transfer_slot != null:
			carried_object.pick_up(transfer_slot)
			carried_object = null
		elif carried_object == null and transfer_slot != null:

			if transfer_slot.crafting:
				return
			var pick_item = transfer_slot.carried_objects.pop_front()
			if pick_item:
				pick_item.leave()
				pick_item.pick_up(self)


func _physics_process(delta):
	
	if transfer_slot != null and transfer_slot.blocked:
		transfer_slot = null
	
	linear_velocity += gravity * delta
	
	var anim = ANIM_FLOOR
	
	var vv = linear_velocity.y # Vertical velocity.
	var hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.
	
	var hdir = hv.normalized() # Horizontal direction.
	var hspeed = hv.length() # Horizontal speed.
	
	# Player input.
	var dir = Vector3() # Where does the player intend to walk to.

	# cam_basis is now the root node of player!
	var cam_basis = get_global_transform().basis

	dir = (Input.get_action_strength(player_prefix + "move_left") - Input.get_action_strength(player_prefix + "move_right")) * cam_basis[2]
	dir += (Input.get_action_strength(player_prefix + "move_backwards") - Input.get_action_strength(player_prefix + "move_forward")) * cam_basis[0] 

	dir.y = 0.0
	dir = dir.normalized()
	
	var jump_attempt = Input.is_action_pressed(player_prefix + "jump")
	var shoot_attempt = Input.is_action_pressed(player_prefix + "shoot")
	
	if is_on_floor():
		var sharp_turn = hspeed > 0.1 and rad2deg(acos(dir.dot(hdir))) > movement_profiles[cur_movement]['sharp_turn_threshold']
		if dir.length() > 0.1 and !sharp_turn:
			if hspeed > 0.001:
				hdir = adjust_facing(hdir, dir, delta, 1.0 / hspeed * TURN_SPEED, Vector3.UP)
			else:
				hdir = dir
			
			if hspeed < movement_profiles[cur_movement]['max_speed']:
				hspeed += movement_profiles[cur_movement]['accel'] * delta
		else:
			hspeed -= movement_profiles[cur_movement]['deaccel'] * delta
			if hspeed < 0:
				hspeed = 0
		
		hv = hdir * hspeed
		
		var mesh_xform = get_node("Armature").get_transform()

		var facing_mesh = -mesh_xform.basis[0].normalized()
		facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()
		if hspeed > 0:
			facing_mesh = adjust_facing(facing_mesh, dir, delta, 1.0 / hspeed * TURN_SPEED, Vector3.UP)
		var m3 = Basis(-facing_mesh, Vector3.UP, -facing_mesh.cross(Vector3.UP).normalized()).scaled(CHAR_SCALE)
		get_node("Armature").set_transform(Transform(m3, mesh_xform.origin))
		
		if not jumping and jump_attempt:
			vv = 7.0
			jumping = true
			get_node("SoundJump").play()
	else:
		anim = ANIM_AIR
		
		if dir.length() > 0.1:
			hv += dir * (movement_profiles[cur_movement]['accel'] * 0.2 * delta)
			if hv.length() > movement_profiles[cur_movement]['max_speed']:
				hv = hv.normalized() * movement_profiles[cur_movement]['max_speed']
		else:
			if air_idle_deaccel:
				hspeed = hspeed - (movement_profiles[cur_movement]['deaccel'] * 0.2 * delta)
				if hspeed < 0:
					hspeed = 0
				hv = hdir * hspeed
	
	if jumping and vv < 0:
		jumping = false
	
	linear_velocity = hv + Vector3.UP * vv
	
	if is_on_floor():
		movement_dir = linear_velocity
		
	linear_velocity = move_and_slide(linear_velocity, -gravity.normalized())
	
	if shoot_blend > 0:
		shoot_blend -= delta * SHOOT_SCALE
		if (shoot_blend < 0):
			shoot_blend = 0
	
	if shoot_attempt and not prev_shoot:
		shoot_blend = SHOOT_TIME
		var bullet = preload("res://player/bullet/bullet.tscn").instance()
		bullet.set_transform(get_node("Armature/Bullet").get_global_transform().orthonormalized())
		get_parent().add_child(bullet)
		bullet.set_linear_velocity(get_node("Armature/Bullet").get_global_transform().basis[2].normalized() * 20)
		bullet.add_collision_exception_with(self) # Add it to bullet.
		get_node("SoundShoot").play()
	
	prev_shoot = shoot_attempt
	
	if is_on_floor():
		$AnimationTree["parameters/walk/blend_amount"] = hspeed / movement_profiles[cur_movement]['max_speed']
	
	$AnimationTree["parameters/state/current"] = anim
	$AnimationTree["parameters/air_dir/blend_amount"] = clamp(-linear_velocity.y / 4 + 0.5, 0, 1)
	$AnimationTree["parameters/gun/blend_amount"] = min(shoot_blend, 1.0)

	check_pickup_area()

func start_powerup(powerup='powerup'):
	set_movement(powerup)
	$PowerUpTimer.start()

func set_movement(mode):
	assert(mode in movement_profiles)
	cur_movement = mode

func reset_movement():
	cur_movement = 'normal'

func check_pickup_area():
	var items = $Armature/Skeleton/PickupArea.get_overlapping_bodies()
	pickitem = null
	for p_body in items:
		if p_body.has_method("pick_up"):
			pickitem = p_body


func adjust_facing(p_facing, p_target, p_step, p_adjust_rate, current_gn):
	var n = p_target # Normal.
	var t = n.cross(current_gn).normalized()
	 
	var x = n.dot(p_facing)
	var y = t.dot(p_facing)
	
	var ang = atan2(y,x)
	
	if abs(ang) < 0.001: # Too small.
		return p_facing
	
	var s = sign(ang)
	ang = ang * s
	var turn = ang * p_adjust_rate * p_step
	var a
	if ang < turn:
		a = ang
	else:
		a = turn
	ang = (ang - a) * s
	
	return (n * cos(ang) + t * sin(ang)) * p_facing.length()

func throw_item():
	if !carried_object:
		return
	carried_object.throw(movement_profiles[cur_movement]['throw_power'])


func _on_PickupArea_body_entered(body):
	if body.has_method("add_object") and !body.blocked:
		transfer_slot = body
	elif body.has_method("action"):
		interact_object = body

func _on_PickupArea_body_exited(body):

	if body.has_method("add_object") and !body.blocked:
		transfer_slot = null
		if body.crafting == true:
			body.abort_craft()
	elif body.has_method("action"):
		interact_object = null

