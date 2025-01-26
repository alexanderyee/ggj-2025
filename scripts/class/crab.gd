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
@onready var needs: Needs = $Defineneeds


@onready var random_move_pos_target : Vector3 = Vector3.ZERO
@onready var currently_random_moving : bool = false


@onready var random_move_pos_target : Vector3 = Vector3.ZERO
@onready var currently_random_moving : bool = false

var current_fixation = null
var current_objects_within_fov := []

func _ready() -> void:
	timer.wait_time = tick_length_milliseconds / 1000.0
	detection_sphere.shape.radius = fov_radius_meters
	crab_voice.stream = AudioStreamPolyphonic.new()
	crab_voice.stream.polyphony = 32

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var do_we_want_to_move : bool = false
	var move_target_pos : Vector3 = Vector3.ZERO
	# check if an object is within the crab's FOV
	var objects_within_fov : Array[Node3D] = crab_vision.get_overlapping_bodies()
	# sort objects by distance from crab
	objects_within_fov.sort_custom(sort_objects_within_crab_vision)
	current_objects_within_fov = objects_within_fov.duplicate()
	if objects_within_fov.size() > 0:
		var closest_object = objects_within_fov[0]
		current_fixation = closest_object
		if current_fixation.get_groups().find("hand") >= 0:
			# crabs will be attracted to the hand that feeds them
			do_we_want_to_move = true
			move_target_pos = current_fixation.position
	else:
		current_fixation = null
	
	if !do_we_want_to_move:
		if !currently_random_moving:#we're chillin, should we start moving?
			var rand_chance : float =  randf_range(0.0, 1.0) * delta
			
			if rand_chance < 0.005:#we're starting a move
				currently_random_moving = true
				random_move_pos_target = Vector3(randf_range(-11.0, 11.0), -1.5, randf_range(-5.5, 5.5))
		if currently_random_moving:
			move_target_pos = random_move_pos_target
			do_we_want_to_move = true
			currently_random_moving = (move_target_pos-global_position).length()>0.55*scale.x
	else:#if we're fixatin, random move should be on ice
		currently_random_moving = false
	
	#we know if and where we wnat to move, lets go
	if do_we_want_to_move:
		var direction = move_target_pos - position
		var speed_mod : float = 1.0
		if currently_random_moving: speed_mod = 0.3
		if direction:
			velocity.x = direction.x * speed * speed_mod
			velocity.z = direction.z * speed * speed_mod
		
		var look_target : Vector3 = move_target_pos
		if currently_random_moving:
			look_target = global_position + (look_target - global_position).rotated(Vector3.UP,deg_to_rad(90))
		
		var current_ang : float = global_rotation.y
		look_at(look_target)
		var modified_ang : float = global_rotation.y
		global_rotation.y = lerp_angle(current_ang, modified_ang, delta*2.0)
	else:
		velocity = Vector3.ZERO
		scuttle_vfx.stop()
		
	move_and_slide()
	if not scuttle_vfx.playing:
		scuttle_vfx.play()

func emote() -> void:
	# bubble up what the crab is thinking
	
	# update crab's needs every crab tick
	# TODO make these enums in global
	## 0 = food 
	## 1 = shelter
	## 2 = comfort
	## 3 = community
	var all_groups_within_fov = []
	if !current_objects_within_fov.is_empty():
		# get groups of each object within fov
		for fixation in current_objects_within_fov:
			var fixation_groups = fixation.get_groups()
			for fixation_group in fixation_groups:
				all_groups_within_fov.append(fixation_group)
	adjust_needs(all_groups_within_fov)
		
	# play TTS soundfx
	if !crab_voice.playing:
		crab_voice.play()
	
	var crab_voice_polyphonic := crab_voice.get_stream_playback()
	# TODO: this should play what the crab is feeling as well, we only play
	# whatever's near the crab currently
	
	if (!all_groups_within_fov.is_empty()):
		var rng = RandomNumberGenerator.new()
		var emote_to_play_index = rng.randi_range(0, all_groups_within_fov.size() - 1)
		var emote_to_play = all_groups_within_fov[emote_to_play_index]
		if (Global.crab_tts_sounds.has(emote_to_play)):
			var tts_emote_to_play_stream = Global.crab_tts_sounds[emote_to_play]
			# TODO adjust pitch_scale to make crab tts sound a bit more natural
			crab_voice_polyphonic.play_stream(tts_emote_to_play_stream)
	
	pass

# return true if obj1 is closer to this crab than obj2
func sort_objects_within_crab_vision(obj1, obj2):
	if global_transform.origin.distance_to(obj1.global_transform.origin) < \
		global_transform.origin.distance_to(obj2.global_transform.origin):
			return true
	return false

func adjust_needs(all_groups_within_fov):
	# TODO maybe there's a better way to keep track of whether a need is being
	#      currently met... but we got 2 hours
	var need_counter = [0, 0, 0, 0]
	for group in all_groups_within_fov:
		if group == "food":
			needs.increase(Global.CRAB_NEEDS.FOOD)
			need_counter[Global.CRAB_NEEDS.FOOD] += 1
		if group == "shelter":
			needs.increase(Global.CRAB_NEEDS.SHELTER)
			need_counter[Global.CRAB_NEEDS.SHELTER] += 1
		if group == "comfort":
			needs.increase(Global.CRAB_NEEDS.COMFORT)
			need_counter[Global.CRAB_NEEDS.COMFORT] += 1
		if group == "community":
			needs.increase(Global.CRAB_NEEDS.COMMUNITY)
			need_counter[Global.CRAB_NEEDS.COMMUNITY] += 1
	for i in range(need_counter.size()):
		if need_counter[i] <= 0:
			needs.decrease(i)
		

func _on_timer_timeout() -> void:
	emote()
	pass # Replace with function body.
