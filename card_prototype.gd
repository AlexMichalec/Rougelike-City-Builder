extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	text = ["Kopalnia", "Browar", "Karczma", "Kościół", "Cmentarz", "Targowisko", "Domy", "Bloki"].pick_random()
	var temp = get_theme_stylebox("normal").duplicate()
	temp.bg_color = Color.from_hsv(randf(),0.8,0.8)
	add_theme_stylebox_override("normal", temp )
