extends Node

@onready var gold_text : Label = $TestLabel

# Thousands handles 0-999999 so players can spend ex: 234, gold on random items 
var gold = {
	
	"Thousands" : 500,
	"Millions" : 997,
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

# only here to track timer. count++ when 1 sec passes
var curTime = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_goldText()
	#print(gold)
	#pass

func _process(delta: float) -> void:
	pass

# updates TestLabel on the UI only
# Should format where it is gold[highestUsedOrderofMag-1].gold[highestUsedOrderofMag]
func _update_goldText():
	var largestNumAt = 0;
	var gold_text_formatted = "";
	var keyNow = "";


	# !!!!for loops format the text, fix later please 
	# This and below can be made simpler somehow, and more efficient !!!!
	# vvvvv
	for key in gold:
		if gold[key] >= 1:
			keyNow = key;
	
	for num in range(gold.values().size()):
		
		if gold.values()[num] >= 1:
			largestNumAt = num 
			
	
	gold_text_formatted = str(gold.values()[largestNumAt],".",
						gold.values()[largestNumAt-1]," ",keyNow)
	
	#^^^^^^^^^^^^^
	# !!!! FIX UP TO HERE !!!! 
	
	print(largestNumAt)
	print("formatted text:",gold_text_formatted,"\n",
			#"prevkey: ",prevKey,"\n",
			"keynow: ",keyNow,"\n",
			#"emptykey: ",emptyKey,"\n"
			)
	print(gold.values())
	#this gold should be the formatted version
	gold_text.text = str(gold_text_formatted,"\n",gold)


# This function should be called by gold making entities after they add gold 
# to the above dictionary
func goldOverCheck():
	# Amount of millions in the value of Thousands
	var thousandsCheck = gold["Thousands"]/1000000;
	# Amount of millions in the value of Infinities
	var infinitiesCheck = gold["Infinities"]/1000000;
	# Amount of thousands in the value of other between numbers
	var overflow = 0;
	
	#print("thous ",thousandsCheck)
	#print("inf ",infinitiesCheck)
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
				print("I'm in 999 and ", key, " has been overflowed")
				
	_update_goldText()


# Below is a test of how each entity would call goldOverCheck()
# add gold to gold dict, then overflow check. Each entity may have a timer,
# or check for a global one.
func _on_timer_timeout() -> void:
	print("hello " , curTime)
	
	print(gold)
	gold["Thousands"] += 0;
	gold["Millions"] += 90860;
	goldOverCheck();
	curTime+=1;
