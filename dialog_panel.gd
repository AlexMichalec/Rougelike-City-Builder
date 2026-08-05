extends PanelContainer
var sample_text = ["Ja Asgard Wielki, władca Taphloon, imperator Caligary...",
"...i tak dalej, i tak dalej",
"zlecam Ci wybudowanie nowej osady dla naszej wspaniałej cywilizacji",
"Dostaniesz trochę złota i potrzebne plany",
"Jakie jest twoje imie?",
"...",
"Heh nie jesteś zbyt rozmowny",
"Wybierz swoją ekipę",
"Miejsce gdzie chcesz zbudować",
"Dalej ruszaj",
"Masz 100 dni"]
var is_writing = false
var line_index = -1
var skip = false
@export var time_interval = 0.1
@export var fade_out_time = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SampleLabel.visible = false
	ResourceLoader.load_threaded_request("res://MainScene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if is_writing:
			skip = true
		else:
			next_line()
		
func next_line():
	is_writing = true
	line_index += 1
	if sample_text.size() <= line_index:
		var tween = get_tree().create_tween()
		tween.tween_property(%FadeOut,"modulate",Color.BLACK,fade_out_time)
		await tween.finished
		print(ResourceLoader.load_threaded_get_status("res://MainScene.tscn") == ResourceLoader.THREAD_LOAD_LOADED)
		var newScene = ResourceLoader.load_threaded_get("res://MainScene.tscn")
		get_tree().change_scene_to_packed(newScene)
		return
	var new_label = %SampleLabel.duplicate()
	new_label.visible = true
	new_label.text = ""
	%DialogContainer.add_child(new_label)
	for word in sample_text[line_index].split(""):
		%ScrollContainer.scroll_vertical = %DialogContainer.size.y
		new_label.text += word

		if !skip:
			await get_tree().create_timer(time_interval).timeout
		else:
			new_label.text = sample_text[line_index]
			skip = false
			next_line()
			return
	skip = false
	is_writing = false
	
