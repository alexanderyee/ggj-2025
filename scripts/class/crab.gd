class_name Crab
extends CharacterBody3D


@export var tick_length_milliseconds := 1000 # could randomize this
@export var fov_radius_meters := 0.5
@onready var timer: Timer = $Timer
@onready var detection_sphere: CollisionShape3D = $CrabVision/CollisionShape3D
@onready var crab_vision: Area3D = $CrabVision

func _ready() -> void:
	timer.wait_time = tick_length_milliseconds / 1000.0
	detection_sphere.shape.radius = fov_radius_meters

func _physics_process(delta: float) -> void:
	pass

func emote() -> void:
	# check if an object is within the crab's FOV
	var objects_within_fov : Array[Node3D] = crab_vision.get_overlapping_bodies()
	# sort objects by distance from crab
	objects_within_fov.sort_custom(sort_objects_within_crab_vision)
	if objects_within_fov.size() > 0:
		print(objects_within_fov[0])
		
	# bubble up what the crab is thinking
	
	# play TTS soundfx
	
	pass

# return true if obj1 is closer to this crab than obj2
func sort_objects_within_crab_vision(obj1, obj2):
	if global_transform.origin.distance_to(obj1.global_transform.origin) < \
		global_transform.origin.distance_to(obj2.global_transform.origin):
			return true
	return false

func _on_timer_timeout() -> void:
	emote()
	pass # Replace with function body.
