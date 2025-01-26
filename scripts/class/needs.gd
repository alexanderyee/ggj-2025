extends Node3D

class_name Needs

# These are set to 60, because starting at 100%
# of a property would be boring.
@export var food : = 60
@export var shelter : = 60
@export var comfort : = 60
@export var community : = 60

var total

# Called when the node enters the scene tree for the first time.
# initialize variables
func _ready() -> void:
	
	#get the values from the crab
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Find the total amount of need points
func find_total():
	total = food + shelter + comfort + community
	return total

## Directly read a need
## 0 = food
## 1 = shelter
## 2 = comfort
## 3 = community
func read_need(stat_id: int):
	
	if stat_id == 0:	
		return food
			
	elif stat_id == 1:
		return shelter
			
	elif stat_id == 2:
		return comfort
			
	else:
		return community

## Directly edit a need
## 0 = food
## 1 = shelter
## 2 = comfort
## 3 = community
func change_need(stat_id: int, number: int):
	
	if stat_id == 0:	
		food = number
			
	elif stat_id == 1:
		shelter = number
			
	elif stat_id == 2:
		comfort = number
			
	else:
		community = number

## Increase a stat, 0-3
func increase(stat_id: int):
	
	if stat_id == 0:	
		if food < 100:
			food = food + 1
			
	elif stat_id == 1:
		if shelter < 100:
			shelter = shelter + 1
			
	elif stat_id == 2:
		if comfort < 100:
			comfort = comfort + 1
			
	else:
		if community < 100:
			community = community + 1

## Decrease a stat, 0-3
func decrease(stat_id: int):
	
	if stat_id == 0:	
		if food > 0:
			food = food - 1
			
	elif stat_id == 1:
		if shelter > 0:
			shelter = shelter - 1
			
	elif stat_id == 2:
		if comfort > 0:
			comfort = comfort - 1
			
	else:
		if community > 0:
			community = community - 1

## Increase a stat, 0-3, by a specified amount
func increase_by(stat_id: int, add: int):
	
	if stat_id == 0:	
		if food < 100:
			food = food + add
			
	elif stat_id == 1:
		if shelter < 100:
			shelter = shelter + add
			
	elif stat_id == 2:
		if comfort < 100:
			comfort = comfort + add
			
	else:
		if community < 100:
			community = community + add

## Decrease a stat, 0-3, by a specified amount
func decrease_by(stat_id: int, sub: int):
	
	if stat_id == 0:	
		if food > 0:
			food = food - sub
			
	elif stat_id == 1:
		if shelter > 0:
			shelter = shelter - sub
			
	elif stat_id == 2:
		if comfort > 0:
			comfort = comfort - sub
			
	else:
		if community > 0:
			community = community - sub
