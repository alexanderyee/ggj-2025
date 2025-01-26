extends RayCast3D

@export var step_target : Marker3D
@export var crab_model : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hit_pos = get_collision_point()
	if hit_pos:
		var crabvec : Vector3 = crab_model.global_position - hit_pos
		var ang1 : float = atan2(crabvec.x, crabvec.z)
		var ang2 : float = atan2(crab_model.current_move_vec.x, crab_model.current_move_vec.z)
		var mod : float = crab_model.speed
		mod = min(2.0, mod)
		
		if abs(angle_difference(ang1, ang2)) < 1.5:
			hit_pos += crab_model.current_move_vec*0.5*mod
		else:
			hit_pos += crab_model.current_move_vec*0.2*mod
		step_target.global_position = hit_pos
