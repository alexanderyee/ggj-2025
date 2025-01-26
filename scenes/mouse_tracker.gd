extends Marker3D
@onready var mouse_position_body: CharacterBody3D = $MousePositionBody
@onready var csg_sphere_3d: CSGSphere3D = $MousePositionBody/CSGSphere3D

var mouse_position_3d : Vector3

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# get mouse position in 3d space
	var params := PhysicsRayQueryParameters3D.new()
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	params.from = camera.project_ray_origin(mouse_position)
	params.to = camera.project_position(mouse_position, 100)
	params.collision_mask = 1
	var collision = get_world_3d().direct_space_state.intersect_ray(params)
	
	if collision.has("position"):
		mouse_position_body.position = collision.position
		mouse_position_3d = collision.position
		
	pass
