extends Control
@export var cards_amount = 12
var seen_index = 0
var is_rotating = false
var cards_library:Array
var cards_in_hand:Array
const LIBRARY_PATH = "res://data/CardsLibrary.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_cards_lib()
	cards_in_hand = []
	for i in range(cards_amount):
		var new_card:Card = %Card.duplicate()
		%CardsWheel.add_child(new_card)
		
		new_card.in_hand = i==0
		new_card.size = Vector2(150,200)
		new_card.pivot_offset = Vector2(75,200)
		new_card.text = "Card " + str(i)
		new_card.rotation = 2 * PI * float(i) / cards_amount
		new_card.global_position = %CardsWheel.global_position + Vector2(-75,-360).rotated(TAU * float(i) / cards_amount)
		var card_info = cards_library.pick_random()
		while(card_info in cards_in_hand):
			card_info = cards_library.pick_random()
		cards_in_hand.append(card_info)
		new_card.gen_from_info(card_info)
	%Card.queue_free()
	await get_tree().create_timer(0.1).timeout
	update_alpha()


func reset_cards():
	%CardsWheel.rotation = 0
	seen_index = 0
	cards_amount -= 1
	await get_tree().create_timer(0.1).timeout
	for i in range(%CardsWheel.get_child_count()):
		var card = %CardsWheel.get_child(i)
		card.rotation = 2 * PI * float(i) / cards_amount
		card.global_position = %CardsWheel.global_position + Vector2(-75,-360).rotated(TAU * float(i) / cards_amount)
	update_alpha()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right") and !is_rotating:
		is_rotating = true
		var tween = get_tree().create_tween()
		tween.tween_property(%CardsWheel, "rotation",%CardsWheel.rotation - 2 * PI / cards_amount,0.2)
		%CardsWheel.get_child(seen_index).in_hand = false
		%CardsWheel.get_child(seen_index).reset_scale()
		seen_index += 1
		if seen_index ==cards_amount:
			seen_index = 0
		%CardsWheel.get_child(seen_index).in_hand = true
		update_alpha()
		await tween.finished
		
		is_rotating = false
		print(%CardsWheel.global_position)
	if Input.is_action_just_pressed("ui_left") and !is_rotating:
		is_rotating = true
		var tween = get_tree().create_tween()
		tween.tween_property(%CardsWheel, "rotation",%CardsWheel.rotation + 2 * PI / cards_amount,0.2)
		%CardsWheel.get_child(seen_index).in_hand = false
		%CardsWheel.get_child(seen_index).reset_scale()
		seen_index -= 1
		if seen_index == -1:
			seen_index = cards_amount-1
		%CardsWheel.get_child(seen_index).in_hand = true
		update_alpha()
		await tween.finished
		is_rotating = false

func update_alpha():
	var tween2 = get_tree().create_tween()
	tween2.set_parallel(true)
	for i in range(%CardsWheel.get_child_count()):
		if i == seen_index:
			tween2.tween_property(%CardsWheel.get_child(i),"modulate",Color(1,1,1,1),0.2)
			#%CardsWheel.get_child(i).modulate=Color(1,1,1,1)
			%CardsWheel.get_child(i).z_index = 20
		elif abs(seen_index-i) == 1 or seen_index == 0 and i == cards_amount-1 or seen_index == cards_amount -1 and i == 0 :
			tween2.tween_property(%CardsWheel.get_child(i),"modulate",Color(1,1,1,0.7),0.2)
			#%CardsWheel.get_child(i).modulate=Color(1,1,1,0.8)
			%CardsWheel.get_child(i).z_index = 10
		elif abs(seen_index-i) == 2 or seen_index == 0 and i == cards_amount-2 or seen_index == 1 and i == cards_amount-1 or seen_index == cards_amount -1 and i == 1 or seen_index == cards_amount -2 and i == 0 :
			tween2.tween_property(%CardsWheel.get_child(i),"modulate",Color(1,1,1,0.3),0.2)
			#%CardsWheel.get_child(i).modulate=Color(1,1,1,0.6)
			%CardsWheel.get_child(i).z_index = 5
		else:
			tween2.tween_property(%CardsWheel.get_child(i),"modulate",Color(1,1,1,0),0.2)
			#%CardsWheel.get_child(i).modulate=Color(1,1,1,0)
			


func _on_left_pressed() -> void:
	Input.action_press("ui_left")
	Input.action_release("ui_left")


func _on_right_pressed() -> void:
	Input.action_press("ui_right")
	Input.action_release("ui_right")


func _on_main_scene_update_cards() -> void:
	reset_cards()

func load_cards_lib():
	if !FileAccess.file_exists(LIBRARY_PATH):
		return false
	var library_file = FileAccess.open(LIBRARY_PATH,FileAccess.READ)
	var saved_library = JSON.parse_string(library_file.get_line())
	cards_library = []
	for info in saved_library:
		cards_library.append(CardInfo.from_dict(info))
	return true
