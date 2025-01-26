extends Node

# Constants
# there should be an .mp3 for each of these in assets/sfx/tts/
# TODO: make these into resources and add an audiolibrary class
const crab_sound_names = ["crab", "hand", "frightened", "scared", "food", "comfort", "shelter", "bubble"]
var crab_tts_sounds = {}
## 0 = food
## 1 = shelter
## 2 = comfort
## 3 = community
enum CRAB_NEEDS {FOOD, SHELTER, COMFORT, COMMUNITY}
@onready var drag_n_drop_manager: DragAndDrop3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload_crab_voices()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func preload_crab_voices() -> void:
	for crab_sound_name in crab_sound_names:
		var file = FileAccess.open("res://assets/sfx/tts/" + crab_sound_name + ".mp3", FileAccess.READ)
		var sound = AudioStreamMP3.new()
		sound.data = file.get_buffer(file.get_length())
		crab_tts_sounds[crab_sound_name] = sound
