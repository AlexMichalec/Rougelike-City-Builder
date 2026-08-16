extends Node


# Called when the node enters the scene tree for the first time.
func add(res_name:String, amount:int):
	match res_name:
		"Gold":
			get_tree().current_scene.gold += amount
		"Materials":
			get_tree().current_scene.materials += amount
		"Energy":
			get_tree().current_scene.energy += amount
		_:
			print("Wrong resource name: " + res_name)
	get_tree().current_scene.update_resource_label()
	
func reduce(res_name:String, amount:int):
	match res_name:
		"Gold":
			get_tree().current_scene.gold = max(get_tree().current_scene.gold -amount,0)
		"Materials":
			get_tree().current_scene.materials += max(get_tree().current_scene.materials -amount,0)
		"Energy":
			get_tree().current_scene.energy += max(get_tree().current_scene.energy -amount,0)
		_:
			print("Wrong resource name: " + res_name)
	get_tree().current_scene.update_resource_label()
	
