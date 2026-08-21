extends Node
var effect_sum = {}
var effect_time = -1

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
	
func get_effect_dict(actions_array:Array) -> Dictionary:
	var result = {}
	for action:Dictionary in actions_array:
		if action["type"] == "Add":
			var amount = int(action.get("amount",0))	
			if result.has(action["resource"]):
				result[action["resource"]] += amount
			else:
				result[action["resource"]] = amount
		elif action["type"] == "Reduce":
			var amount = int(action.get("amount",0))
			if result.has(action["resource"]):
				result[action["resource"]] -= amount
			else:
				result[action["resource"]] = -amount
		elif action["type"] == "Draw":
			result = "+ "
			var amount = int(action.get("amount",0))
			if result.has("Card"):
				result["Card"] += amount
			else:
				result["Card"] = amount
	return result
				
func get_effect_text(actions_array:Array) -> String:
	var effects_dict = get_effect_dict(actions_array)
	add_effect_to_sum(effects_dict)
	return get_effect_dict_to_str(effects_dict)
	
func add_effect_to_sum(effects_dict:Dictionary):
	for key in effects_dict.keys():
		if effect_sum.has(key):
			effect_sum[key] += effects_dict[key]
		else:
			effect_sum[key] = effects_dict[key]
		
func reset_effect_sum():
	effect_sum = {}
	
func get_effect_sum_text():
	return get_effect_dict_to_str(effect_sum)
	
func get_effect_dict_to_str(effects_dict:Dictionary):
	var result = ""
	for key in effects_dict.keys():
		var amount_str = str(effects_dict[key])
		if amount_str[0] == "0":
			continue
		if amount_str[0] != "-":
			amount_str = "+" + amount_str
		result +=  amount_str + " " + key + ", "
	result = result.trim_suffix(", ")
	return result
	
	
