extends Needs

## emoteID should go from 0 - 8. 0 is the 'nothing' emote. 
@export var emoteID : int = 0

@export var crabCoords : CollisionShape3D

@export var speechSprite : Sprite3D
@export var foodSprite : Sprite3D
@export var shelterSprite : Sprite3D
@export var comfortSprite : Sprite3D
@export var communitySprite : Sprite3D

var foodTimer : float = -60
var shelterTimer : float = -60
var comfortTimer : float = -60
var communityTimer : float = -60

var foodEmoteTimer : float
var shelterEmoteTimer : float
var comfortEmoteTimer : float
var communityEmoteTimer : float

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
  
	speechSprite.transparency = 1
	foodSprite.transparency = 1
	shelterSprite.transparency = 1
	comfortSprite.transparency = 1
	communitySprite.transparency = 1
	
	emote(1)
	emote(2)
	emote(3)
	emote(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	checkneed(0)
	checkneed(1)
	checkneed(2)
	checkneed(3)
	
	checkpercentage(food, 0)
	checkpercentage(shelter, 1)
	checkpercentage(comfort, 2)
	checkpercentage(community, 3)
	
	setcoords(0)
	setcoords(1)
	setcoords(2)
	setcoords(3)
	
	updatespritetimer(delta)

func emote(stat_id):
	findsprite(stat_id)
	startspritetimer(stat_id)

func setcoords(stat_id):
	
	speechSprite.global_position.x = crabCoords.global_position.x + (stat_id * 10)
	
	var temp = speechSprite.global_position.x
	
	speechSprite.global_position.y = crabCoords.global_position.y + 500
	speechSprite.global_position.z = crabCoords.global_position.z + 500
	
	if stat_id == 1:
		foodSprite.global_position.x = crabCoords.global_position.x + (stat_id / 50)
		
	elif stat_id == 2:
		shelterSprite.global_position.x = crabCoords.global_position.x + (stat_id / 50)
		
	elif stat_id == 3:
		comfortSprite.global_position.x = crabCoords.global_position.x + (stat_id / 50)
		
	elif stat_id == 4:
		communitySprite.global_position.x = crabCoords.global_position.x + (stat_id / 50)

func findsprite(stat_id):
	
	# I'm not just putting speechsprite up here, because
	# of the fact that stat_id == 0 means nothing should be showing.
	if stat_id == 1:
		speechSprite.transparency = 0
		foodSprite.transparency = 0
	elif stat_id == 2:
		speechSprite.transparency = 0
		shelterSprite.transparency = 0
	elif stat_id == 3:
		speechSprite.transparency = 0
		comfortSprite.transparency = 0
	elif stat_id == 4:
		speechSprite.transparency = 0
		communitySprite.transparency = 0

func startspritetimer(stat_id):
	if stat_id == 1:	
		foodEmoteTimer = 5
		
	elif stat_id == 2:
		shelterEmoteTimer = 5
		
	elif stat_id == 3:
		comfortEmoteTimer = 5
		
	elif stat_id == 4:
		communityEmoteTimer = 5

func updatespritetimer(subtract):
	if foodEmoteTimer != -60:
		foodEmoteTimer -= subtract
		if foodEmoteTimer <= 0:
			speechSprite.transparency = 1
			foodSprite.transparency = 1
			foodEmoteTimer = -60
	
	if shelterEmoteTimer != -60:
		shelterEmoteTimer -= subtract
		if shelterEmoteTimer <= 0:
			speechSprite.transparency = 1
			shelterSprite.transparency = 1
			shelterEmoteTimer = -60
	
	if comfortEmoteTimer != -60:
		comfortEmoteTimer -= subtract
		if comfortEmoteTimer <= 0:
			speechSprite.transparency = 1
			comfortSprite.transparency = 1
			comfortEmoteTimer = -60
	
	if communityEmoteTimer != -60:
		communityEmoteTimer -= subtract
		if communityEmoteTimer <= 0:
			speechSprite.transparency = 1
			communitySprite.transparency = 1
			communityEmoteTimer = -60

##  0-3 - Check whether the need has to be fucked with or not
func checkneed(stat_id: int): 
	
	# The prevFood stuff is to make sure that checkPercentage doesn't get 
	# called every frame, because this func has to be updated!
	# Basically, it tells it if there's no change, don't fuck with the timers.

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
				emote(1)
				checkneed(0)
		
	elif stat_id == 1:
		shelterTimer = shelterTimer - subtract;
		
		if shelterTimer <= 0:
			if shelterTimer > -60:

				emote(2)
				checkneed(1)
		
	elif stat_id == 2:
		comfortTimer = comfortTimer - subtract;
		
		if comfortTimer <= 0:
			if comfortTimer > -60:
				emote(3)

				checkneed(2)
		
	else:
		communityTimer = communityTimer - subtract;
		
		if communityTimer <= 0:
			if communityTimer > -60:
				emote(4)
				checkneed(3)
