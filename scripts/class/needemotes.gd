extends Needs

class_name EmoteNeeds

## emoteID should go from 0 - 8. 0 is the 'nothing' emote. 
@export var emoteID : int = 0

@export var crabCoords : CollisionShape3D

@export var speechFoodSprite : Sprite3D
@export var speechShelterSprite : Sprite3D
@export var speechComfortSprite : Sprite3D
@export var speechCommunitySprite : Sprite3D

@export var foodSprite : Sprite3D
@export var shelterSprite : Sprite3D
@export var comfortSprite : Sprite3D
@export var communitySprite : Sprite3D

var foodTimer : float = -60
var shelterTimer : float = -60
var comfortTimer : float = -60
var communityTimer : float = -60
var winTimer : float = -60

var foodEmoteTimer : float
var shelterEmoteTimer : float
var comfortEmoteTimer : float
var communityEmoteTimer : float

var foodTimerOn : bool = false
var shelterTimerOn : bool = false
var comfortTimerOn : bool = false
var communityTimerOn : bool = false
var winTimerOn : bool = false

var wincondition : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	wincondition = 0
	
	speechFoodSprite.transparency = 1
	speechShelterSprite.transparency = 1
	speechComfortSprite.transparency = 1
	speechCommunitySprite.transparency = 1
	
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
	
	setcoords(0)
	setcoords(1)
	setcoords(2)
	setcoords(3)
	
	countdowntimer(0, delta)
	countdowntimer(1, delta)
	countdowntimer(2, delta)
	countdowntimer(3, delta)
	countdowntimer(4, delta)
	
	updatespritetimer(delta)

func emote(stat_id):
	findsprite(stat_id)
	startspritetimer(stat_id)

func setcoords(stat_id):
	
	var xCoords : int = crabCoords.global_position.x + (stat_id / 50)
	
	if stat_id == 1:
		speechFoodSprite.global_position.x = xCoords
		foodSprite.global_position.x = xCoords
		
	elif stat_id == 2:
		speechShelterSprite.global_position.x = xCoords
		shelterSprite.global_position.x = xCoords
		
	elif stat_id == 3:
		speechComfortSprite.global_position.x = xCoords
		comfortSprite.global_position.x = xCoords
		
	elif stat_id == 4:
		speechCommunitySprite.global_position.x = xCoords
		communitySprite.global_position.x = xCoords

func findsprite(stat_id):
	
	# I'm not just putting speechsprite up here, because
	# of the fact that stat_id == 0 means nothing should be showing.
	if stat_id == 1:
		speechFoodSprite.transparency = 0
		foodSprite.transparency = 0
	elif stat_id == 2:
		speechShelterSprite.transparency = 0
		shelterSprite.transparency = 0
	elif stat_id == 3:
		speechComfortSprite.transparency = 0
		comfortSprite.transparency = 0
	elif stat_id == 4:
		speechCommunitySprite.transparency = 0
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
			speechFoodSprite.transparency = 1
			foodSprite.transparency = 1
			foodEmoteTimer = -60
	
	if shelterEmoteTimer != -60:
		shelterEmoteTimer -= subtract
		if shelterEmoteTimer <= 0:
			speechShelterSprite.transparency = 1
			shelterSprite.transparency = 1
			shelterEmoteTimer = -60
	
	if comfortEmoteTimer != -60:
		comfortEmoteTimer -= subtract
		if comfortEmoteTimer <= 0:
			speechComfortSprite.transparency = 1
			comfortSprite.transparency = 1
			comfortEmoteTimer = -60
	
	if communityEmoteTimer != -60:
		communityEmoteTimer -= subtract
		if communityEmoteTimer <= 0:
			speechCommunitySprite.transparency = 1
			communitySprite.transparency = 1
			communityEmoteTimer = -60

##  0-4 - Check whether the need has to be fucked with or not
func checkneed(stat_id: int): 
	
	# The prevFood stuff is to make sure that checkPercentage doesn't get 
	# called every frame, because this func has to be updated!
	# Basically, it tells it if there's no change, don't fuck with the timers.

	if stat_id == 0:	
		if !foodTimerOn:
			checkpercentage(food, stat_id)
		
	elif stat_id == 1:
		if !shelterTimerOn:
			checkpercentage(shelter, stat_id)
		
	elif stat_id == 2:
		if !comfortTimerOn:
			checkpercentage(comfort, stat_id)
		
	elif stat_id == 3:
		if !communityTimerOn:
			checkpercentage(community, stat_id)
	
	else:
		if !winTimerOn:
			checkpercentage(-99, 4)

func checkpercentage(need: int, stat_id: int):
	
	if need < 25 && need > 0:
		starttimer(stat_id, 15)
		winTimer = -60
		winTimerOn = false
		
	elif need < 50 && need > 0:
		starttimer(stat_id, 30)
		winTimer = -60
		winTimerOn = false
		
	elif need < 75 && need > 0:
		starttimer(stat_id, 60)
		winTimer = -60
		winTimerOn = false
		
	elif need < 100:
		if ((food >= 75) || (shelter >= 75) || (comfort >= 75) || (community >= 75)) && (winTimerOn == false):
			winTimerOn = true
			starttimer(4, 15)

func starttimer(stat_id: int, time: float):
	
	if stat_id == 0:	
		foodTimer = time
		foodTimerOn = true
		
	elif stat_id == 1:
		shelterTimer = time
		shelterTimerOn = true
		
	elif stat_id == 2:
		comfortTimer = time
		comfortTimerOn = true
		
	elif stat_id == 3:
		communityTimer = time
		communityTimerOn = true
	
	else:
		winTimer = time
		winTimerOn = true

func countdowntimer(stat_id: int, subtract: float):
	
	if stat_id == 0:
		foodTimer = foodTimer - subtract;
		
		if foodTimer <= 0:
			if foodTimer > -60:
				
				emote(1)
				checkneed(0)
				foodTimerOn = false
		
	elif stat_id == 1:
		shelterTimer = shelterTimer - subtract;
		
		if shelterTimer <= 0:
			if shelterTimer > -60:
				
				emote(2)
				checkneed(1)
				shelterTimerOn = false
		
	elif stat_id == 2:
		comfortTimer = comfortTimer - subtract;
		
		if comfortTimer <= 0:
			if comfortTimer > -60:
				
				emote(3)
				checkneed(2)
				comfortTimerOn = false
		
	elif stat_id == 3:
		communityTimer = communityTimer - subtract;
		
		if communityTimer <= 0:
			if communityTimer > -60:
				
				emote(4)
				checkneed(3)
				communityTimerOn = false
	
	else:
		winTimer = winTimer - subtract;
		
		if winTimer <= 0:
			if winTimer > -60:
				
				wincondition += 1
				winTimerOn = false
