extends Button
class_name Card
@export var in_hand = true
@export var goal_scale = 1.2
@export var art_files : Array[Texture2D]
@export var chosen_color = Color.DARK_VIOLET
var title:String
var cost:Array[int]
var to_build = false
var old_styleboxes:Dictionary
var card_info:CardInfo

@onready var delete_button: Button = %DeleteButton


signal delete_card
signal try_to_build


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if delete_button.visible:
		delete_button.modulate = Color(1.0, 1.0, 1.0, 0.8)
	if in_hand:
		var tween = get_tree().create_tween()
		tween.tween_property(self,"scale",Vector2(goal_scale,goal_scale),0.5)


func _on_mouse_exited() -> void:
	if to_build:
		return
	if delete_button.visible:
		delete_button.modulate = Color.TRANSPARENT
	if in_hand or scale.x>1:
		var tween = get_tree().create_tween()
		tween.tween_property(self,"scale",Vector2(1,1),0.5)

func reset_scale():
	_on_mouse_exited()
		
func gen_random():
	%GoldCost.text = str(randi_range(0,7))
	%EnergyCost.text = str(randi_range(0,7))
	%MaterialCost.text = str(randi_range(0,7))
	cost = [int(%GoldCost.text),int(%EnergyCost.text),int(%MaterialCost.text)]
	var art_file:Texture2D = art_files.pick_random()
	title = art_file.resource_path.split("/")[-1].rstrip(".png")
	%Title.text = title
	%Art.texture = art_file
	%Actions.get_children().pick_random().visible = false
	if (randf()<0.5):
		%Actions.get_children().pick_random().visible = false

func gen_from_info(new_card_info:CardInfo, in_list = false):
	card_info = new_card_info
	%Title.text = card_info.title
	%GoldCost.text = str(card_info.cost[0])
	%EnergyCost.text = str(card_info.cost[1])
	%MaterialCost.text = str(card_info.cost[2])
	cost = card_info.cost
	if card_info.art_card:
		%Art.texture = load(card_info.art_card)
	else:
		%Art.texture = load("res://icon.svg")
	var single_action_added = false
	for i in range(3):
		var action = [%RedAction, %BlueAction, %GreenAction][i]
		var new_text = [card_info.red_action_text, card_info.blue_action_text, card_info.green_action_text][i]
		if new_text == "":
			action.visible = false
		else:
			single_action_added = true
			action.visible = true
			action.get_node("Label").text = new_text
	%Actions.visible = single_action_added
	%Any.visible = card_info.any_action_text!=""
	%AnyAction.text = card_info.any_action_text
	%OnBuild.visible = card_info.on_build_action_text!=""
	%OnBuildAction.text = card_info.on_build_action_text
	delete_button.visible = in_list
	delete_button.modulate = Color.TRANSPARENT
		
		

func _on_pressed() -> void:
	try_to_build.emit(self)
	
func stay_big():
	var new_stylebox:StyleBox = get_theme_stylebox("hover").duplicate()
	new_stylebox.border_color = chosen_color
	old_styleboxes.clear()
	old_styleboxes["normal"] = get_theme_stylebox("normal").duplicate()
	old_styleboxes["hover"] = get_theme_stylebox("hover").duplicate()
	add_theme_stylebox_override("hover", new_stylebox)
	add_theme_stylebox_override("normal", new_stylebox)
	
	
	
	to_build = true
	
func undo_chosen():
	add_theme_stylebox_override("hover", old_styleboxes["hover"])
	add_theme_stylebox_override("normal", old_styleboxes["normal"])
	to_build = false
	


func _on_delete_button_pressed() -> void:
	delete_card.emit()
