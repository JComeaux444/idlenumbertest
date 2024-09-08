extends Node


# Thousands handles 0-999999 so players can spend ex: 234, gold on random items 
var gold = {
	
	"Thousands" : 500,
	"Millions" : 997,
	"Billions" : 999,
	"Trillions" : 999,
	"Quadrillion" : 999,
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

var curTime = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(gold)
	pass

func _process(delta: float) -> void:
	pass



func goldOverCheck():
	# Amount of millions in the value of Thousands
	var thousandsCheck = gold["Thousands"]/1000000;
	# Amount of millions in the value of Infinities
	var infinitiesCheck = gold["Infinities"]/1000000;
	# Amount of thousands in the value of other between numbers
	var overflow = 0;
	
	print("thous ",thousandsCheck)
	print("inf ",infinitiesCheck)
	for key in gold:
		
		# if something before us overflowed, take the overflow and add to self
		if overflow >= 1:
			gold[key] += overflow;
		
		# reset overflow
		overflow = 0;
		
		if key == "Thousands":
			if thousandsCheck >= 1:
				gold["Thousands"] -= thousandsCheck * 1000000
				print("It went over!")
				overflow += thousandsCheck
			
		elif key  == "Infinities":
			if infinitiesCheck >= 1:
				gold["Infinities"] -= infinitiesCheck * 1000000
				print("It went over 1M inf!")
				# Really should never get here. If they do, True Infinity 
				# will basically be an over flow where anything over 1 lets you
				# buy anything
				print("We have a very large number approaching True Infinity")
			
		else: 
			# For every other number, it should only hold 999 of itself 
			# ex: 999 Million going to 1000 Million, Will be 1 M and 1 Billion
			# when done executing.
			if key != "True Infinity" && gold[key] > 999:
				overflow = gold[key]/1000
				gold[key] -= overflow*1000
				print("I'm in 999")
				


func _on_timer_timeout() -> void:
	print("hello " , curTime)
	goldOverCheck();
	print(gold)
	gold["Thousands"] += 0;
	gold["Millions"] += 90860;
	curTime+=1;
