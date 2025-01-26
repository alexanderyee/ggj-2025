extends Node3D
@onready var camera :Camera3D = $Camera3D
@onready var crab_collider : CollisionShape3D = $CollisionShape3D
@onready var crab_target_pos : Vector3 = Vector3(0.0, 0.5, 0.0)
@onready var crab_rot : float = 0.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("emotion1"):$CollisionShape3D/CrabModel.set_normal()
	if Input.is_action_pressed("emotion2"):$CollisionShape3D/CrabModel.set_shock()
	if Input.is_action_pressed("emotion3"):$CollisionShape3D/CrabModel.set_sad()
	if Input.is_action_pressed("emotion4"):$CollisionShape3D/CrabModel.set_angry()
	
	if Input.is_action_pressed("click"):
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
	
	crab_collider.global_position = crab_collider.global_position.lerp(crab_target_pos, delta*10.0)
	#print(crab_collider.global_position)
	
	if Input.is_action_pressed("turn_left"): crab_rot += delta*7.0
	if Input.is_action_pressed("turn_right"): crab_rot -= delta*7.0
	
	
	crab_collider.global_transform.basis = Transform3D.IDENTITY.basis
	crab_collider.rotate_y(crab_rot)

func get_mouse_pos():
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x, 0.0, get_viewport().size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0.0, get_viewport().size.y)
	return mouse_pos
