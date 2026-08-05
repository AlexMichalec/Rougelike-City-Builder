extends Node2D
var testing_fade = true
@export var fade_in_time = 1.5

var gold = 0
var energy = 0
var materials = 0
var build_mode = 0 #0 - nie budujesz, 1 - wybierz kartę, 2 - wybierz hexa, 3 buduję
@onready var InfoLabel = %InfoLabel
@onready var LeftArrow = %Left
@onready var UndoChooseBuilding: Button = %Undo
@onready var RightArrow: Button = %Right
@onready var hex_map: Control = $HexMap
@onready var mode_label: Label = %ModeLabel
@onready var right_hand: Control = %RightHand



var chosen_card:Card

signal update_cards


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mode_label.text = ""
	InfoLabel.text = ""
	gold = randi_range(5,15)*10
	energy = randi_range(5,15)*10
	materials = randi_range(5,15)*10
	update_resource_label()
	if testing_fade:
		%FadePanel.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(%FadePanel,"modulate",Color(0,0,0,0.01), fade_in_time)
		await tween.finished
		#%FadePanel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()
	
func update_resource_label():
	%ResourcesLabel.text = "Resources:\nGold: {0}\nEnergy: {1}\nMaterials: {2}".format([gold,energy,materials])




func try_to_build(card:Card) -> void:
	if build_mode != 1:
		return
	if card.cost[0] > gold or card.cost[1] > energy or card.cost[2] > materials:
		InfoLabel.text = "Not Enough Resources!"
	else:
		#gold -= card.cost[0]
		#energy -= card.cost[1]
		#materials -= card.cost[2]
		update_resource_label()
		InfoLabel.text = "Choose a hex where you want to put the Building"
		UndoChooseBuilding.visible = true
		LeftArrow.visible = false
		RightArrow.visible = false
		card.stay_big()
		chosen_card = card
		build_mode = 2
		hex_map.build_mode_on = true
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(right_hand,"scale",Vector2(1,1),0.8)
		Global.chosen_card["title"] = card.title


func _on_build_button_pressed() -> void:
	if build_mode == 0:
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(right_hand,"scale",Vector2(1.2,1.2),0.8)
		mode_label.text = "MODE: BUILD"
		build_mode = 1
		InfoLabel.text = "Build Mode activated\nChoose a project to build"


func undo_choose_project() -> void:
	build_mode = 1
	LeftArrow.visible = true
	RightArrow.visible = true
	UndoChooseBuilding.visible = false
	chosen_card.undo_chosen()
	chosen_card.reset_scale()
	InfoLabel.text = "Choose a Project to build!"
	hex_map.build_mode_on = false
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(right_hand,"scale",Vector2(1.2,1.2),0.8)
	
	
	


func _on_hex_map_building_started() -> void:
	UndoChooseBuilding.visible = false
	var new_tween = get_tree().create_tween()
	var goal_position = chosen_card.global_position
	goal_position.y = -400
	energy -= chosen_card.cost[1]
	update_resource_label()
	new_tween.tween_property(chosen_card,"global_position",goal_position,0.75)
	InfoLabel.text = "Building..."


func _on_hex_map_building_finished() -> void:
	InfoLabel.text = ""
	gold -= chosen_card.cost[0]
	materials -= chosen_card.cost[2]
	update_resource_label()
	build_mode = 0
	RightArrow.visible = true
	LeftArrow.visible = true
	chosen_card.queue_free()
	update_cards.emit()
	mode_label.text = ""
	#chosen_card.queue_free()
	
	
