extends Node

var gold = {
	
	"Thousands" : 0,
	"Millions" : 0,
	"Billions" : 0,
	"Trillions" : 0,
	"Quadrillion" : 0,
	"Quintillion" : 0,
	"Sextillion" : 0,
	"Septillion" : 0,
	"Octillion" : 0,
	"Nonillion" : 0,
	"Decillion" : 0,
	"Undecillion" : 0,
	"Duodecillion" : 0,
	"Infinities" : 0,
	"True Infinity" : 0
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func goldOverCheck(gold: Dictionary):
	# Amount of millions in the value of Thousands
	var thousandsCheck = gold["Thousands"]%1000000;
	# Amount of millions in the value of Infinities
	var infinitiesCheck = gold["Infinities"]%1000000;
	# Amount of thousands in the value of other between numbers
	var overflow = 0;
	
	for key in gold:
		
		# if something before us overflowed, take the overflow and add to self
		if overflow > 1:
			gold[key] += overflow;
		
		# reset overflow
		overflow = 0;
		
		if key == "Thousands":
			if thousandsCheck > 1:
				gold["Thousands"] -= thousandsCheck * 1000000
			
		elif key  == "Infinities":
			if infinitiesCheck > 1:
				# Really should never get here. If they do, True Infinity 
				# will basically be an over flow where anything over 1 lets you
				# buy anything
				print("We have a very large number approaching True Infinity")
			
		else: 
			if gold[key] > 999:
				overflow = gold[key]%1000
				gold[key] -= overflow*1000
				
