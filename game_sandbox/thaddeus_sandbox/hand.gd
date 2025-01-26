extends Node3D

@onready var animplayer = $hand/AnimationPlayer
@onready var y_target : float = 1.0
@onready var grabbing : bool:
	set(value):
		if value != grabbing:
			if value:
				animplayer.play("Grab", -1, 1.5)
			else:
				animplayer.play("Grab", -1, -1.5, true)
		grabbing = value


@onready var armature = $hand/Armature
@onready var pos_lastframe : Vector3 = Vector3.ZERO
@onready var hand_rot : Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grabbing = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	grabbing = Input.is_action_pressed("click")
	
	global_position.y = lerpf(global_position.y , y_target, delta*10.0)
	
	var current_move_vec = global_position-pos_lastframe
	
	pos_lastframe = global_position
	rotation = Vector3.ZERO
	current_move_vec*=0.5
	hand_rot.x = lerpf(hand_rot.x, -current_move_vec.z, 0.1)
	hand_rot.y = lerpf(hand_rot.y, -current_move_vec.x, 0.1)
	rotate_x(hand_rot.x)
	rotate_z(hand_rot.y)
	
