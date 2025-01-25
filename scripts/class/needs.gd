extends CrabNeeds

class_name Needs

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
