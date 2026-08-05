extends CanvasLayer
@export var texture_array : Array[Texture2D]
@onready var sample_button: Button = %SampleButton
@onready var art_grid: GridContainer = %ArtGrid

signal art_chosen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for art in texture_array:
		var new_button = sample_button.duplicate()
		new_button.get_child(0).get_child(0).texture = art
		art_grid.add_child(new_button)
		new_button.pressed.connect(send_path.bind(art.resource_path))
	sample_button.visible = false
	
func send_path(path_to_art:String):
	art_chosen.emit(path_to_art)
	visible = false


func _on_cancel_pressed() -> void:
	visible = false


func _on_scale_slider_value_changed(value: float) -> void:
	var new_min_size = Vector2(300,150) * value
	art_grid.columns = int((get_viewport().get_visible_rect().size.x-100)/new_min_size.x)
	for butt:Button in art_grid.get_children():
		butt.custom_minimum_size = new_min_size
		butt.custom_maximum_size = new_min_size
	
