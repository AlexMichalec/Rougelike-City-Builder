extends Node

func use(actions_array):
	for action in actions_array:
		if action["type"] == "Add":
			ResourceManager.add(action["resource"], action["amount"])
		elif action["type"] == "Reduce":
			ResourceManager.reduce(action["resource"], action["amount"])
		elif action["type"] == "Draw":
			pass
			
func get_text(action:Dictionary):
	var result = ""
	if !action.has("type"):
		return result
	if action["type"] == "Add":
		var amount = int(action.get("amount",0))	
		result = "+" + str(amount) + " " + action.get("resource","")
	elif action["type"] == "Reduce":
		var amount = int(action.get("amount",0))
		result = "-" + str(amount) + " " + action.get("resource","")
	elif action["type"] == "Draw":
		result = "Draw "
		if action.has("amount"):
			result += str(int(action["amount"])) + " Card"
			result += ("" if action["amount"] == 1 else "s")
		else:
			result += "..."
	return result
	
func get_effect_text(action:Dictionary):
	var result = ""
	if !action.has("type"):
		return result
	if action["type"] == "Add":
		var amount = int(action.get("amount",0))	
		result = "+" + str(amount) + " " + action.get("resource","")
	elif action["type"] == "Reduce":
		var amount = int(action.get("amount",0))
		result = "-" + str(amount) + " " + action.get("resource","")
	elif action["type"] == "Draw":
		result = "+ "
		if action.has("amount"):
			result += str(int(action["amount"])) + " Card"
			result += ("" if action["amount"] == 1 else "s")
		else:
			result += "..."
	return result
