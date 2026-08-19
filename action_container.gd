class_name ActionContainer
extends HBoxContainer
var edited_card:CardInfo

@onready var add_action: Button = %AddAction
@onready var color_button: OptionButton = %ColorButton
@onready var type_button: OptionButton = %TypeButton
@onready var amount: SpinBox = %Amount
@onready var resource: OptionButton = %Resource
@onready var condition: OptionButton = %Condition
@onready var remove_action: Button = %RemoveAction

var prev_color = ""
var action_dict = {}


signal add_new_action
signal remove_the_action
signal actions_changed

func _ready() -> void:
	color_button.visible = false
	type_button.visible = false
	amount.visible = false
	resource.visible = false
	condition.visible = false
	remove_action.visible = false
	
func gen_from_info(color:String, action:Dictionary):
	prev_color = color
	color_button.visible = true
	color_button.select(["Red", "Green", "Blue", "Any", "OnBuild"].find(color))
	type_button.select(["Add","Reduce","Draw"].find(action.get("type")))
	type_button.visible = true
	if action.get("type") in ["Add", "Reduce"]:
		resource.visible = true
		resource.select(["Gold", "Energy", "Materials"].find(action.get("resource")))
	amount.value = action.get("amount",0)
	amount.visible = amount.value!=0
	add_action.visible = false
	remove_action.visible = true
	action_dict = action

func _on_add_action_pressed() -> void:
	add_action.visible = false
	color_button.visible = true
	color_button.select(3)
	type_button.visible = true
	type_button.select(0)
	resource.visible = true
	resource.select(0)
	amount.value = 1
	amount.visible = true
	remove_action.visible = true
	add_new_action.emit()
	prev_color = "Any"
	action_dict["type"] = "Add"
	action_dict["amount"] = 1
	action_dict["resource"] = "Gold"
	if edited_card.actions.has("Any"):
		edited_card.actions["Any"].append(action_dict)
	else:
		edited_card.actions["Any"] = [action_dict]
	actions_changed.emit()
	


	


func _on_remove_action_pressed() -> void:
	add_action.visible = true
	color_button.visible = false
	type_button.visible = false
	amount.visible = false
	resource.visible = false
	condition.visible = false
	remove_action.visible = false
	edited_card.actions[prev_color].erase(action_dict)
	if edited_card.actions[prev_color].size() == 0:
		edited_card.actions.erase(prev_color)
	remove_the_action.emit(self)
	prev_color = ""
	actions_changed.emit()
	


func _on_type_button_item_selected(index: int) -> void:
	var type_chosen = type_button.get_item_text(index)
	action_dict["type"] = type_chosen
	if type_chosen == "Add":
		amount.visible = true
		amount.value = 1
		resource.visible = true
		resource.selected = 0
		#condition.visible = true
		#condition.selected = 0
		action_dict["amount"] = 1
		action_dict["resource"] = resource.get_item_text(0)
	elif type_chosen == "Reduce":
		amount.visible = true
		amount.value = 1
		resource.visible = true
		resource.selected = 0
		#condition.visible = true
		#condition.selected = 0
		action_dict["amount"] = 1
		action_dict["resource"] = resource.get_item_text(0)
	elif type_chosen == "Draw":
		amount.visible = true
		amount.value = 1
		resource.visible = false
		resource.selected = 0
		#condition.visible = true
		#condition.selected = 0
		action_dict["amount"] = 1
		action_dict.erase("resource")
	actions_changed.emit()


func _on_color_button_item_selected(index: int) -> void:
	if prev_color != "":
		edited_card.actions[prev_color].erase(action_dict)
		if edited_card.actions[prev_color].size() == 0:
			edited_card.actions.erase(prev_color)
		
	var color_chosen = color_button.get_item_text(index)
	prev_color = color_chosen
	if edited_card.actions.has(color_chosen):
		edited_card.actions[color_chosen].append(action_dict)
	else:
		edited_card.actions[color_chosen] = [action_dict]
	actions_changed.emit()
		


func _on_amount_value_changed(value: float) -> void:
	action_dict["amount"] = int(value)
	actions_changed.emit()


func _on_resource_item_selected(index: int) -> void:
	var resource_name = resource.get_item_text(index)
	action_dict["resource"] = resource_name
	actions_changed.emit()
