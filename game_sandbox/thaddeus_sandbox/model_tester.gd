extends Node3D
@onready var camera :Camera3D = $Camera3D
@onready var crab_collider : CollisionShape3D = $CollisionShape3D
@onready var crab : Node3D = $CollisionShape3D/CrabModel
@onready var crab_target_pos : Vector3 = Vector3(0.0, 0.5, 0.0)
@onready var crab_rot : float = 0.0

@export var max_crab_speed : float = 5.0

@onready var crab_snip_timer : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("emotion1"):$CollisionShape3D/CrabModel.set_normal()
	if Input.is_action_pressed("emotion2"):$CollisionShape3D/CrabModel.set_shock()
	if Input.is_action_pressed("emotion3"):$CollisionShape3D/CrabModel.set_sad()
	if Input.is_action_pressed("emotion4"):$CollisionShape3D/CrabModel.set_angry()
	
	#if Input.is_action_pressed("click"):
	var mouse_pos = get_mouse_pos()
	var start = camera.project_ray_origin(mouse_pos)
	var end = start + camera.project_ray_normal(mouse_pos) * camera.get_far()
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var raycast_query = PhysicsRayQueryParameters3D.create(start, end)
	raycast_query.collision_mask = 0b1 #masked to collision layer 1
	var result = space_state.intersect_ray(raycast_query)
	
	if result != {}:
		var collider = result.collider.get_parent()
		
		var new_pos : Vector3 = result.position
		new_pos.y += 0.5
		crab_target_pos = new_pos
	
	var lerped_pos : Vector3 = crab_collider.global_position.lerp(crab_target_pos, delta*10.0)
	var move_vec : Vector3 = lerped_pos - crab_collider.global_position
	var length : float = move_vec.length()
	length = min(max_crab_speed*delta, length)
	move_vec = move_vec.normalized() *length
	
	crab_collider.global_position += move_vec
	
	crab_snip_timer -= delta
	if crab_snip_timer <= 0.0:
		crab_snip_timer = randf_range(2.0,8.0)
		crab.animplayer.play("Snap")
		
	
	
	if (crab_target_pos - crab_collider.global_position).length() > 0.1:
		var look_target : Vector3 = crab_target_pos
		var current_ang : float = crab_collider.global_rotation.y
		crab_collider.look_at(look_target)
		var modified_ang : float = crab_collider.global_rotation.y
		
		var dir_mod : float = -deg_to_rad(90)
		if angle_difference(current_ang, modified_ang) < 0.0:
			dir_mod *= -1.0
		
		look_target = crab.global_position + (look_target-crab.global_position).rotated(Vector3.UP,dir_mod)
		crab_collider.look_at(look_target)
		modified_ang = crab_collider.global_rotation.y
		
		crab_collider.global_rotation.y = lerp_angle(current_ang, modified_ang, delta*4.0)
	
	

func get_mouse_pos():
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x, 0.0, get_viewport().size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0.0, get_viewport().size.y)
	return mouse_pos
