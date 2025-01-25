extends Needs

var foodTimer : float
var shelterTimer : float
var comfortTimer : float
var communityTimer : float

var foodXCoord : int = 0
var shelterXCoord : int = 20
var comfortXCoord : int = 40
var communityXCoord : int = 60

var prevFood : int
var prevShelter : int
var prevComfort : int
var prevCommunity : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevFood = food
	prevShelter = shelter
	prevComfort = comfort
	prevCommunity = community

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	checkneed(0)
	checkneed(1)
	checkneed(2)
	checkneed(3)

##  0-3
func checkneed(stat_id: int): 

	if stat_id == 0:	
		if prevFood != food:
			checkpercentage(food, stat_id)
		prevFood = food
		
	elif stat_id == 1:
		if prevShelter != shelter:
			checkpercentage(shelter, stat_id)
		prevShelter = shelter
		
	elif stat_id == 2:
		if prevComfort != comfort:
			checkpercentage(comfort, stat_id)
		prevComfort = comfort
		
	else:
		if prevCommunity != community:
			checkpercentage(community, stat_id)
		prevCommunity = community

func checkpercentage(need: int, stat_id: int):
	
	if need < 25:
		starttimer(stat_id, 15)
		
	elif need < 50:
		starttimer(stat_id, 30)
		
	elif need < 75:
		starttimer(stat_id, 60)
		
		# I'm putting this below 0 so that when remaining time is checked,
		# it's going to be out of range and can't possibly be duplicated.
	else:
		starttimer(stat_id, -60)

func starttimer(stat_id: int, time: float):
	
	if stat_id == 0:	
		foodTimer = time;
		
	elif stat_id == 1:
		shelterTimer = time;
		
	elif stat_id == 2:
		comfortTimer = time;
		
	else:
		communityTimer = time;

func countdowntimer(stat_id: int, subtract: float):
	
	if stat_id == 0:
		foodTimer = foodTimer - subtract;
		
		if foodTimer <= 0:
			if foodTimer > -60:
				#Emote
				checkneed(0)
		
	elif stat_id == 1:
		shelterTimer = shelterTimer - subtract;
		
		if shelterTimer <= 0:
			if shelterTimer > -60:
				#Emote
				checkneed(1)
		
	elif stat_id == 2:
		comfortTimer = comfortTimer - subtract;
		
		if comfortTimer <= 0:
			if comfortTimer > -60:
				#Emote
				checkneed(2)
		
	else:
		communityTimer = communityTimer - subtract;
		
		if communityTimer <= 0:
			if communityTimer > -60:
				#Emote
				checkneed(3)
