extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# get list of all crabs
	get_children().duplicate()
	# check if two crabs that are near each other have maxed community (optionally, maxed food?)
	
	# spawn baby in-between parents
	# remove crabs from list of candidates to spawn from
	# reset their community level
	
	pass
