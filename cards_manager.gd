extends Control
@onready var grid: GridContainer = %GRID
@onready var save: Button = %SAVE
@onready var create: Button = %Create
@export var card_scene:PackedScene
@onready var cards_list: VBoxContainer = %CardsList
@onready var card_editor: VBoxContainer = %CardEditor
@onready var choose_art: CanvasLayer = %ChooseArt

var cards_library:Array[CardInfo] = []
var is_deleting = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	gen_from_arts()
	
func gen_from_arts():
	for art:Texture2D in choose_art.texture_array:
		var new_card_info = CardInfo.new()
		for ii in range(3):
			new_card_info.cost[ii] = randi_range(0,5)
		var new_card :Card = card_scene.instantiate()
		new_card_info.art_card = art.resource_path
		new_card_info.title = art.resource_path.split("/")[-1].rstrip(".png")
		new_card.visible = true
		grid.add_child(new_card)
		new_card.in_hand = false
		new_card.gen_from_info(new_card_info, true)
		new_card.pressed.connect(open_editor.bind(new_card_info,new_card))
		new_card.delete_card.connect(delete_card.bind(new_card, new_card_info))
		cards_library.append(new_card_info)
	create.move_to_front()

func gen_empty():
	for i in range(20):
		var new_card_info = CardInfo.new()
		for ii in range(3):
			new_card_info.cost[ii] = randi_range(0,5)
			new_card_info.red_action_text = "TEST"
		var new_card :Card = card_scene.instantiate()
		new_card.visible = true
		grid.add_child(new_card)
		new_card.in_hand = false
		new_card.gen_from_info(new_card_info, true)
		new_card.pressed.connect(open_editor.bind(new_card_info,new_card))
		new_card.delete_card.connect(delete_card.bind(new_card, new_card_info))
		cards_library.append(new_card_info)
	create.move_to_front()


func _on_create_pressed() -> void:
	var new_card_info = CardInfo.new()
	var new_card :Card = card_scene.instantiate()
	grid.add_child(new_card)
	new_card.in_hand = false
	new_card.gen_from_info(new_card_info, true)
	cards_library.append(new_card_info)
	new_card.pressed.connect(open_editor.bind(new_card_info,new_card))
	new_card.delete_card.connect(delete_card.bind(new_card, new_card_info))
		
	create.move_to_front()
	
func open_editor(card_info:CardInfo, menu_card:Card):
	if is_deleting:
		return
	card_editor.initialize(card_info, menu_card)
	cards_list.visible = false
	card_editor.visible = true
	

func delete_card(card_to_delete:Card, card_info:CardInfo):
	is_deleting = true
	cards_library.erase(card_info)
	card_to_delete.queue_free()
	await get_tree().create_timer(0.5).timeout
	is_deleting = false



func _on_save_pressed() -> void:
	for card in cards_library:
		print(card.title)
