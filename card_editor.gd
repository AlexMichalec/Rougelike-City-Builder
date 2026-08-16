extends VBoxContainer
@onready var cards_list: VBoxContainer = %CardsList
var card_edited:CardInfo
var card_back_up:CardInfo
var menu_card:Card
@onready var gold_cost: SpinBox = %GoldCost
@onready var energy_cost: SpinBox = %EnergyCost
@onready var material_cost: SpinBox = %MaterialCost
@onready var title_input: LineEdit = %TitleInput



@onready var preview_card: Card = %PreviewCard
@onready var card_art: TextureRect = %CardArt

@onready var choose_art: CanvasLayer = %ChooseArt

@onready var actions_list: VBoxContainer = %ActionsList

@export var action_container_scene :PackedScene





func _ready():
	visible = false

func _on_save_card_pressed() -> void:
	visible = false
	cards_list.visible = true
	menu_card.gen_from_info(card_edited, true)
	print(card_edited.actions)


func _on_cancel_pressed() -> void:
	back_up()
	visible = false
	cards_list.visible = true
	
func initialize(card_info:CardInfo, the_menu_card:Card):
	card_edited = card_info
	create_back_up()
	print("Editing started")
	title_input.text = card_edited.title
	gold_cost.value = card_info.cost[0]
	energy_cost.value = card_info.cost[1]
	material_cost.value = card_info.cost[2]
	#for color:Array in card_info.actions:
	#	for action:Dictionary in color:
			
	
	card_art.texture = load(card_info.art_card)
	preview_card.gen_from_info(card_edited)
	menu_card = the_menu_card
	for child in actions_list.get_children():
		child.queue_free()
		
	for color_name in card_info.actions.keys():
		var color_array = card_info.actions[color_name]
		for action in color_array:
			add_new_action()
			actions_list.get_child(-1).gen_from_info(color_name,action)
			
		
	add_new_action()
	
		
	
	
func create_back_up():
	card_back_up = CardInfo.new()
	card_back_up.title = card_edited.title
	card_back_up.cost[0] = card_edited.cost[0]
	card_back_up.cost[1] = card_edited.cost[1]
	card_back_up.cost[2] = card_edited.cost[2]
	card_back_up.category = card_edited.category
	card_back_up.art_card = card_edited.art_card
	card_back_up.art_hex = card_edited.art_hex
	card_back_up.art_hex_big = card_edited.art_hex_big
	for color_name in card_edited.actions.keys():
		card_back_up.actions[color_name] = []
		var color_array = card_edited.actions[color_name]
		for action:Dictionary in color_array:
			var action_copy ={}
			for key in action.keys():
				action_copy[key] = action[key]
			card_back_up.actions[color_name].append(action_copy)

func back_up():
	card_edited.title = card_back_up.title
	card_edited.cost[0] = card_back_up.cost[0]
	card_edited.cost[1] = card_back_up.cost[1]
	card_edited.cost[2] = card_back_up.cost[2]
	card_edited.category = card_back_up.category
	card_edited.art_card = card_back_up.art_card
	card_edited.art_hex = card_back_up.art_hex
	card_edited.art_hex_big = card_back_up.art_hex_big
	card_edited.actions = card_back_up.actions

	
	


func _on_title_input_text_changed(new_text: String) -> void:
	card_edited.title = new_text
	update_preview()
	

func update_preview():
	preview_card.gen_from_info(card_edited)


func _on_gold_cost_value_changed(value: float) -> void:
	card_edited.cost[0] =  int(value)
	update_preview()

func _on_energy_cost_value_changed(value: float) -> void:
	card_edited.cost[1] = int(value)
	update_preview()

func _on_material_cost_value_changed(value: float) -> void:
	card_edited.cost[2] = int(value)
	update_preview()
	



func _on_red_action_input_text_changed(new_text: String) -> void:
	card_edited.red_action_text = new_text
	update_preview()


func _on_blue_action_input_text_changed(new_text: String) -> void:
	card_edited.blue_action_text = new_text
	update_preview()


func _on_green_action_input_text_changed(new_text: String) -> void:
	card_edited.green_action_text = new_text
	update_preview()
	
	


func _on_choose_art_art_chosen(art_path:String) -> void:
	card_edited.art_card = art_path
	card_art.texture = load(art_path)
	update_preview()


func _on_change_art_pressed() -> void:
	choose_art.visible = true


func _on_any_action_input_text_changed(new_text: String) -> void:
	card_edited.any_action_text = new_text
	update_preview()


func _on_on_build_input_text_changed(new_text: String) -> void:
	card_edited.on_build_action_text = new_text
	update_preview()


func add_new_action() -> void:
	var new_container = action_container_scene.instantiate()
	new_container.edited_card = card_edited
	new_container.add_new_action.connect(add_new_action)
	new_container.remove_the_action.connect(remove_the_action)
	new_container.actions_changed.connect(update_preview)
	actions_list.add_child(new_container)


func remove_the_action(action_container:ActionContainer) -> void:
	if actions_list.get_child_count() > 1:
		action_container.queue_free()
