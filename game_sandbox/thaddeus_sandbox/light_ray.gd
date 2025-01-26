extends Node3D

@onready var ray : Sprite3D = $Sprite3D
@onready var alpha : float = randf_range(0.0, 0.7)
@onready var alpha_going_down : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ray.modulate.a = alpha
	if alpha_going_down:
		alpha -= delta*0.1
		if alpha <= 0.3:
			alpha_going_down = !alpha_going_down
	else:
		alpha += delta*0.1
		if alpha >= 0.8:
			alpha_going_down = !alpha_going_down
