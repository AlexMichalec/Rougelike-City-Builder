class_name BuildingHex
extends Node2D
@onready var title_label: Label = %Title
@onready var info_title: Label = %InfoTitle
@onready var red_action: ColorRect = %RedAction
@onready var green_action: ColorRect = %GreenAction
@onready var blue_action: ColorRect = %BlueAction
@onready var any_action: ColorRect = %AnyAction
@onready var particles_emiter: GPUParticles2D = $Button/ParticlesEmiter
@onready var big_art: TextureRect = %BigArt

@onready var red_action_big: PanelContainer = %RedActionBig
@onready var red_action_label_big: Label = %RedActionLabelBig
@onready var blue_action_big: PanelContainer = %BlueActionBig
@onready var blue_action_label_big: Label = %BlueActionLabelBig
@onready var green_action_big: PanelContainer = %GreenActionBig
@onready var green_action_label_big: Label = %GreenActionLabelBig
@onready var any_action_big: PanelContainer = %AnyActionBig
@onready var any_action_label_big: Label = %AnyActionLabelBig

@onready var effect_label: Label = %EffectLabel







var title = "Placeholder"
var card_info:CardInfo



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button/AnimatedSprite2D.frame = 4
	title_label.text = title
	card_info = Global.chosen_card
	title = card_info.title	
	title_label.text = title
	info_title.text = title
	if title == "Park":
		$Button/AnimatedSprite2D.frame = 0
	elif title == "Factory":
		$Button/AnimatedSprite2D.frame = 1
	elif title == "Latarnia":
		$Button/AnimatedSprite2D.frame = 2
	elif title == "Church":
		$Button/AnimatedSprite2D.frame = 3
	elif title == "Windmill":
		$Button/AnimatedSprite2D.frame = 5
			
	red_action.visible = card_info.actions.has("Red")
	red_action.tooltip_text = get_action_texts("Red")
	blue_action.visible = card_info.actions.has("Blue")
	blue_action.tooltip_text = get_action_texts("Blue")
	green_action.visible = card_info.actions.has("Green")
	green_action.tooltip_text = get_action_texts("Green")
	any_action.visible = card_info.actions.has("Any")
	any_action.tooltip_text = get_action_texts("Any")
	
	Global.buildings_list.append([Global.chosen_coords,self])
	Global.buildings_list.sort_custom(hex_sort)
	print(Global.buildings_list)
	
	ActionManager.use(card_info.actions.get("OnBuild",[]))
	
	big_art.texture = load(card_info.art_card)
	
	red_action_big.visible = card_info.actions.has("Red")
	red_action_label_big.text = get_action_texts("Red")
	blue_action_big.visible = card_info.actions.has("Blue")
	blue_action_label_big.text = get_action_texts("Blue")
	green_action_big.visible = card_info.actions.has("Green")
	green_action_label_big.text = get_action_texts("Green")
	any_action_big.visible = card_info.actions.has("Any")
	any_action_label_big.text = get_action_texts("Any")
	
	
	pass # Replace with function body.
	
func hex_sort(a:Array, b:Array):
	if a[0].y < b[0].y:
		return true
	elif a[0].y == b[0].y and a[0].x<b[0].x:
		return true
	else:
		return false
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$CanvasLayer.visible = true
	
	
	


func _on_back_pressed() -> void:
	$CanvasLayer.visible = false
	


func _on_button_mouse_entered() -> void:
	z_index = 999
	title_label.visible = true
	modulate = Color.WHITE
	

func _on_button_mouse_exited() -> void:
	z_index = 0
	title_label.visible = false
	#modulate = Color(0.859, 0.859, 0.859)
	
func get_action_texts(color:String):
	var result = ""
	for action:Dictionary in card_info.actions.get(color,[]):
		if result != "":
			result += "\n"
		result += ActionManager.get_text(action)
	return result
	
	
func get_attention(color:Color, color_name:String):
	effect_label.text = ActionManager.get_effect_text(card_info.actions[color_name])
	effect_label.visible = true
	$Button.add_theme_stylebox_override("normal", $Button.get_theme_stylebox("hover"))
	$Button.self_modulate = color
	particles_emiter.process_material.color = color
	particles_emiter.restart()
	z_index = 999
	title_label.visible = true

func lose_attention():
	
	$Button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	$Button.self_modulate = Color(0.0, 0.788, 0.922, 0.702)
	z_index = 0
	title_label.visible = false
	await get_tree().create_timer(0.5).timeout
	effect_label.visible = false
	
