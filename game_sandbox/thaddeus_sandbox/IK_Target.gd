extends Marker3D
@export var step_target : Marker3D
@export var crab_model : Node3D

@onready var allowed_to_step : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	#if !is_stepping && !adjacent_target.is_stepping && abs(global_position.distance_to(step_target.global_position)) > step_distance:
	var far : bool = abs(global_position.distance_to(step_target.global_position)) > crab_model.step_distance
	if allowed_to_step and far:
	
		step()
		#opposite_target.step()

func step():
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	#is_stepping = true
	
	var t = get_tree().create_tween()
	#t.tween_property(self, "global_position", half_way + owner.basis.y*0., 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	#t.tween_callback(func(): is_stepping = false)
