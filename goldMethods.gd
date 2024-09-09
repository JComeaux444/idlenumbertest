extends Node

@onready var gold_text : Label = $TestLabel

# Thousands handles 0-999999 so players can spend ex: 234, gold on random items 
var gold = {
	
	"Thousand" : 599998,
	"Million" : 1,
	"Billion" : 0,
	"Trillion" : 0,
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
var largestNumAt = 0;

#not used
var gold_val = [500, 997, 0, 0, 
				0, 0, 0, 0,
				0, 0, 0, 0, 
				0, 0, 0]

# used mainly to quickly compare if Mil > Bil etc
var gold_name = ["Thousand", "Million", "Billion", "Trillion", 
				"Quadrillion", "Quintillion", "Sextillion", "Septillion", 
				"Octillion", "Nonillion", "Decillion", "Undecillion", 
				"Duodecillion", "Infinities", "True Infinity"]

# only here to track timer. count++ when 1 sec passes
var curTime = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_goldText()
	print(gold.keys())
	print()
	print(gold.values())
	#pass

func _process(delta: float) -> void:
	pass

# updates TestLabel on the UI only
# Should format where it is gold[highestUsedOrderofMag-1].gold[highestUsedOrderofMag]
func _update_goldText():
	
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
			
	
	if largestNumAt == 0:
		gold_text_formatted = str(gold.values()[largestNumAt])
	else:
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


# This function should be called by gold making/using entities after they add gold 
# to the above dictionary
func goldOverCheck():
	# Amount of millions in the value of Thousands
	var thousandsCheck = gold["Thousand"]/1000000;
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
		
		if key == "Thousand":
			if thousandsCheck >= 1:
				gold["Thousand"] -= thousandsCheck * 1000000
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

# Only call in UI / onclick of buying an object to confirm if user can afford 
# 
func canBuy(cost : Dictionary = {}):
	
	if !cost.is_empty():
		if cost.size() == 1:
			# current order of magnitude we are at
			var oom = cost.keys()[0]
			# if gold at oom is >= cost we can buy the thing
			if gold[oom] >= cost[oom]:
				return true;
			else:
				#otherwise we check if there is a bigger oom to grab from
				var passedprevOOM = false;
				for name in gold_name:
					#make sure we only grab from a bigger oom
					if passedprevOOM:
						# gold found at the bigger oom 
						if gold[name] > 0:
							# in here we should deincriment the gold (will cause temp overflow)
							# and run this again if we have a larger oom to check too.
							# 
							deIncGold();
							return true;
					if name == oom:
						passedprevOOM = true;
				return false;
					
					
		else: 
			var smaller = false;
			var bigger = true;
			
			# should check the smaller oom first
			print(gold_name.find(cost.keys()[0])," ",gold_name.find(cost.keys()[1]))
			if gold_name.find(cost.keys()[0]) < gold_name.find(cost.keys()[1]):
				smaller = canBuy( {cost.keys()[0] : cost.values()[0]} )
				bigger = canBuy( {cost.keys()[1] : cost.values()[1]} )
			else:
				smaller = canBuy( {cost.keys()[1] : cost.values()[1]} )
				bigger = canBuy( {cost.keys()[0] : cost.values()[0]} )
			
			#Here is where we should call overflow to fix the dictionary, since 
			# we may call this function many times when a UI is opened
			goldOverCheck()
			print( "Can buy smaller? ",smaller )
			print({cost.keys()[0] : cost.values()[0]})
			print( "Can buy bigger? ",bigger )
			print({cost.keys()[1] : cost.values()[1]})
			return (  smaller && bigger  )
		
	pass


func spendGold(spend : Dictionary = {}):
	if !spend.is_empty():
		gold[spend.keys()[0]] -= spend.values()[0];

func deIncGold():
	var index = 0;
	# index 0 is Thousand, inc by 1,000,000
	# index 13 is Infinities, inc by 1,000,000 too
	# index 14 is True Infinity, let that be a normal int, if it overflows 
	# 99.99% user cheated
	for name in gold:
		if index == largestNumAt:
			gold[name] -= 1;
			break;
		if index == 0:
			gold[name] += 1000000;
		elif index == 13:
			gold[name] += 1000000
		elif index == 14:
			pass
		else:
			gold[name] += 999
		index += 1;

# Below is a test of how each entity would call goldOverCheck()
# add gold to gold dict, then overflow check. Each entity may have a timer,
# or check for a global one.
func _on_timer_timeout() -> void:
	#print("hello " , curTime)
	print("Can I buy something for 600k and 1M? ", canBuy({"Thousand":600000,"Million":1}) )
	print(gold)
	gold["Thousand"] += 1;
	gold["Million"] += 0;
	goldOverCheck();
	#curTime+=1;
