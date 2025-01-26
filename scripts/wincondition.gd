extends EmoteNeeds
const winconditionlimit : int = 100

@export var crabs: Array[Crab] = []

@export var bubbles : GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for crab in crabs:
		crab.on_win_cond_changed.connect(checkbubblecount)
	pass

func checkbubblecount(crab):
		wincondition += 1
		if wincondition < winconditionlimit:
		
			crab.win_condition_bubble.emitting = true
			print("Did I win the game? %d" % wincondition)
		#play particle effect
		else:
		#win game
			pass
			
	
