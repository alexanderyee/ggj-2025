extends Needs

var foodTimer : float
var shelterTimer : float
var comfortTimer : float
var communityTimer : float

var foodXCoord : int = 0
var shelterXCoord : int = 20
var comfortXCoord : int = 40
var communityXCoord : int = 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	checkneed(0)
	checkneed(1)
	checkneed(2)
	checkneed(3)

##  0-3
func checkneed(stat_id: int): 

	if stat_id == 0:	
		checkpercentage(food, stat_id)
		
	elif stat_id == 1:
		checkpercentage(shelter, stat_id)
		
	elif stat_id == 2:
		checkpercentage(comfort, stat_id)
		
	else:
		checkpercentage(community, stat_id)

func checkpercentage(need: int, stat_id: int):
	
	if need < 25:
		starttimer(stat_id, 15)
		
	elif need < 50:
		starttimer(stat_id, 30)
		
	elif need < 75:
		starttimer(stat_id, 60)
		
	else:
		starttimer(stat_id, 0)

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
		
	elif stat_id == 1:
		shelterTimer = shelterTimer - subtract;
		
	elif stat_id == 2:
		comfortTimer = comfortTimer - subtract;
		
	else:
		communityTimer = communityTimer - subtract;
