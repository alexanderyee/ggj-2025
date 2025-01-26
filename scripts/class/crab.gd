class_name Crab
extends CharacterBody3D

@export var speed := 1.0
@export var tick_length_milliseconds := 1000 # could randomize this
@export var fov_radius_meters := 0.5
@onready var timer: Timer = $Timer
@onready var detection_sphere: CollisionShape3D = $CrabVision/CollisionShape3D
@onready var crab_vision: Area3D = $CrabVision
@onready var crab_voice: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var crab_model: Node3D = $CollisionShape3D/CrabModel
@onready var scuttle_vfx: AudioStreamPlayer = $ScuttleVFX

var current_fixation = null

func _ready() -> void:
	timer.wait_time = tick_length_milliseconds / 1000.0
	detection_sphere.shape.radius = fov_radius_meters
	crab_voice.stream = AudioStreamPolyphonic.new()
	crab_voice.stream.polyphony = 32

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# check if an object is within the crab's FOV
	var objects_within_fov : Array[Node3D] = crab_vision.get_overlapping_bodies()
	# sort objects by distance from crab
	objects_within_fov.sort_custom(sort_objects_within_crab_vision)
	if objects_within_fov.size() > 0:
		var closest_object = objects_within_fov[0]
		current_fixation = closest_object
		if current_fixation.get_groups().find("hand") >= 0:
			# crabs will be attracted to the hand that feeds them
			var direction = current_fixation.position - position
			if direction:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			
			var current_ang : float = global_rotation.y
			look_at(current_fixation.position)
			var modified_ang : float = global_rotation.y
			global_rotation.y = lerp_angle(current_ang, modified_ang, delta*2.0)
		else:
			velocity = Vector3.ZERO
			scuttle_vfx.stop()
	else:
		current_fixation = null
		velocity = Vector3.ZERO
		scuttle_vfx.stop()
		
	move_and_slide()
	if not scuttle_vfx.playing:
		scuttle_vfx.play()

func emote() -> void:
	
	
	# bubble up what the crab is thinking
	
	# play TTS soundfx
	if !crab_voice.playing:
		crab_voice.play()
	
	var crab_voice_polyphonic := crab_voice.get_stream_playback()
	# TODO: this should play whatever the crab is thinking, we just play a random
	# tts sound for now
	var rng = RandomNumberGenerator.new()
	crab_voice_polyphonic.play_stream(Global.crab_tts_sounds[Global.crab_sound_names[rng.randi_range(0, Global.crab_sound_names.size() - 1)]])
	
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
