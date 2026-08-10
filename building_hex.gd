extends Node2D
@onready var title_label: Label = %Title
@onready var info_title: Label = %InfoTitle

@onready var red_action: ColorRect = $Button/ActionsMini/RedAction
@onready var blue_action: ColorRect = $Button/ActionsMini/BlueAction
@onready var green_action: ColorRect = $Button/ActionsMini/GreenAction


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
			
	red_action.visible = !card_info.red_action_text == ""
	red_action.tooltip_text = card_info.red_action_text
	blue_action.visible = !card_info.blue_action_text == ""
	blue_action.tooltip_text = card_info.blue_action_text
	green_action.visible = !card_info.green_action_text == ""
	green_action.tooltip_text = card_info.green_action_text
		
	pass # Replace with function body.


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
