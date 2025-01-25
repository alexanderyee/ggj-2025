extends Needs

var joy
var content
var sadness
var anger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	manage_joy()
	manage_content()
	manage_sadness()
	manage_anger()

# It probably won't be like this in the future, but it's the basics
# 75 is a percentage, that can absolutely be updated
func manage_joy():
	if food >= 75:
		joy = joy + 1
	
	if shelter >= 75:
		joy = joy + 1
	
	if comfort >= 75:
		joy = joy + 1
	
	if community >= 75:
		joy = joy + 1

func manage_content():
	if (food < 75) && (food >= 50):
		content = content + 1
	
	if (shelter < 75) && (shelter >= 50):
		content = content + 1
	
	if (comfort < 75) && (comfort >= 50):
		content = content + 1
	
	if (community < 75) && (community >= 50):
		content = content + 1

func manage_sadness():
	if (food < 50) && (food >= 25):
		sadness = sadness + 1
	
	if (shelter < 50) && (shelter >= 25):
		sadness = sadness + 1
	
	if (comfort < 50) && (comfort >= 25):
		sadness = sadness + 1
	
	if (community < 50) && (community >= 25):
		sadness = sadness + 1

func manage_anger():
	if food < 25:
		anger = anger + 1
	
	if shelter < 25:
		anger = anger + 1
	
	if comfort < 25:
		anger = anger + 1
	
	if community < 25:
		anger = anger + 1
