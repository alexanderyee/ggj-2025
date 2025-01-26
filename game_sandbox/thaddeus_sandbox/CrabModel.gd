extends Node3D
@export var leg_predictive_factor : float = 1.0
@onready var eyes_target : Marker3D = $EyesTarget
@export var body_rotation_factor : float = 7.0

@onready var step_distance : float = 0.3

@onready var current_step : int = 0
@onready var steptimer : float = 0.0
@onready var steptargets : Array = [$Legs/LegArmatrure/Target_LeftLeg1, $Legs/LegArmatrure/Target_LeftLeg2, 
$Legs/LegArmatrure/Target_LeftLeg3, $Legs/LegArmatrure/Target_RightLeg1, 
$Legs/LegArmatrure/Target_RightLeg2, $Legs/LegArmatrure/Target_RightLeg3]
@onready var crabmesh = $Crab2
@onready var crabmesh_rotate_y : float = 0.0
@onready var mesh_rot : float = 0.0

@onready var speed : float = 0.0
@onready var current_move_vec : Vector3 = Vector3.ZERO
@onready var pos_lastframe : Vector3 = global_position


@onready var eyes = $Crab2/Eyes
@onready var pupil1 = $Crab2/Eyes/Eye/Pupil
@onready var pupil2 = $Crab2/Eyes/Eye2/Pupil
@onready var lid_normal = $Crab2/Eyes/Eye/LidBored
@onready var lid_shock = $Crab2/Eyes/Eye/LidShock
@onready var lid_slant = $Crab2/Eyes/Eye/LidSlant
@onready var lid2_normal = $Crab2/Eyes/Eye2/LidBored
@onready var lid2_shock = $Crab2/Eyes/Eye2/LidShock
@onready var lid2_slant = $Crab2/Eyes/Eye2/LidSlant

@onready var pupil_rot : Vector2 = Vector2.ZERO
@onready var pupil_timer : float = 0.15
enum EMOTIONS {NORMAL=0,SHOCK,SAD,ANGRY}
@onready var current_emotion:# = EMOTIONS.NORMAL
	set(value):
		if value != current_emotion:
			lid_normal.visible = false
			lid_shock.visible = false
			lid_slant.visible = false
			lid2_normal.visible = false
			lid2_shock.visible = false
			lid2_slant.visible = false
			lid_slant.scale = Vector3.ONE
			lid2_slant.scale = Vector3.ONE
			match(value):
				EMOTIONS.NORMAL:
					lid_normal.visible = true
					lid2_normal.visible = true
				EMOTIONS.SHOCK:
					lid_shock.visible = true
					lid2_shock.visible = true
					$Crab2/AnimationPlayer.play("Woah")
				EMOTIONS.SAD:
					lid_slant.visible = true
					lid2_slant.visible = true
				EMOTIONS.ANGRY:
					lid_slant.visible = true
					lid2_slant.visible = true
					lid_slant.scale.x = -1.0
					lid2_slant.scale.x = -1.0
					$Crab2/AnimationPlayer.play("Snap")
		current_emotion = value
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_emotion = EMOTIONS.NORMAL
	
	$Crab2/AnimationPlayer.animation_finished.connect(on_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_move_vec = global_position-pos_lastframe
	speed = current_move_vec.length() * delta * 6000.0
	current_move_vec = current_move_vec.normalized()
	pos_lastframe = global_position
	
	var y_target = atan2(current_move_vec.x, current_move_vec.z) + deg_to_rad(90)
	#crabmesh_rotate_axis = crabmesh_rotate_axis.lerp(rotate_axis_target, delta*20.0)
	crabmesh_rotate_y = lerp_angle(crabmesh_rotate_y, y_target, delta*20.0)
	
	
	crabmesh.rotation = Vector3.ZERO
	crabmesh.global_rotation.y = global_rotation.y
	eyes.rotation = Vector3.ZERO
	
	var crabmesh_rotate_axis = Vector3.FORWARD
	crabmesh_rotate_axis = crabmesh_rotate_axis.rotated(Vector3.UP, crabmesh_rotate_y)
	var mesh_rot_target = min(speed*0.1, 0.5)
	mesh_rot = lerpf(mesh_rot, mesh_rot_target, delta * body_rotation_factor)
	crabmesh.rotate(crabmesh_rotate_axis, mesh_rot)
	
	eyes.rotate(crabmesh_rotate_axis, mesh_rot*2.0)
	
	pupil1.look_at(eyes_target.global_position)
	pupil2.look_at(eyes_target.global_position)
	
	var variance:float = 0.1
	pupil_timer -= delta
	if current_emotion == EMOTIONS.SHOCK: 
		print("FDSd")
		pupil_timer -= delta*5.0
	if pupil_timer <= 0.0:
		pupil_timer = randf_range(0.2, 0.9)
		
		pupil_rot = Vector2(randf_range(-variance, variance), randf_range(-variance, variance))
	pupil1.rotate_x(pupil_rot.y)
	pupil1.rotate_y(pupil_rot.x)
	pupil2.rotate_x(pupil_rot.y)
	pupil2.rotate_y(-pupil_rot.x)
	
	var allowables : Array = [false, false, false, false, false, false]
	allowables[current_step] = true
	allowables[current_step+3] = true
	
	steptimer += delta# * speed
	if steptimer > 0.07: 
		current_step = tri_wrap(current_step)
		steptimer = 0.0
	
	for i in 6:
		steptargets[i].allowed_to_step = allowables[i]
	
	#var meshspeed = 5.0
	#var fl_leg = steptargets[0]
	#var fr_leg = steptargets[3]
	#var bl_leg = steptargets[2]
	#var br_leg = steptargets[4]
	#var avg_y: float = (fl_leg.global_position.y + fr_leg.global_position.y + bl_leg.global_position.y + br_leg.global_position.y) / 4
	#crabmesh.global_position.y = lerp(crabmesh.global_position.y, avg_y + 0.35, meshspeed * delta)
	#
	#var avg_left = (fl_leg.global_position + bl_leg.global_position) / 2
	#var avg_right = (fr_leg.global_position + br_leg.global_position) / 2
 #
	#var diff = Vector2(avg_left.x, avg_left.y).angle_to_point(Vector2(avg_right.x, avg_right.y))
	##crabmesh.global_rotation.z = lerp(crabmesh.global_rotation.z, diff, meshspeed * delta)
	#
	#var avg_back = (bl_leg.global_position + br_leg.global_position) / 2
	#var avg_fwd = (fl_leg.global_position + fr_leg.global_position) / 2
 #
	#var diff2 = Vector2(avg_fwd.z, avg_fwd.y).angle_to_point(Vector2(avg_back.z, avg_back.y))
	##crabmesh.global_rotation.x = lerp(crabmesh.global_rotation.x, -diff2, meshspeed * delta)

func set_normal():
	current_emotion = EMOTIONS.NORMAL

func set_shock():
	current_emotion = EMOTIONS.SHOCK

func set_sad():
	current_emotion = EMOTIONS.SAD
	
func set_angry():
	current_emotion = EMOTIONS.ANGRY


func on_animation_finished():
	$Crab2/AnimationPlayer.play("Idle")

func tri_wrap(num:int):
	num += 1
	if num > 2: num = 0
	return num
