extends StaticBody2D
@export var resourceColor : Color
@export var is_round = false
var spawn_interval = 0.3
var total_value = 0
var sample_res:RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%SampleResource.visible = false
	%SampleRoundResource.visible = false
	sample_res = %SampleRoundResource if is_round else %SampleResource
	$TotalValueLabel.label_settings.font_color = resourceColor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_add_pressed() -> void:
	add_resources(randi_range(3,10))
	
func add_resources(amount:int):
	while amount>5:
		amount -= 5
		var new_resource:RigidBody2D = sample_res.duplicate()
		new_resource.get_child(2).get_child(0).text = "5"
		new_resource.value = 5
		for child in new_resource.get_children():
			child.scale *= 1.3
		new_resource.get_child(1).modulate = resourceColor.darkened(0.2)
		var ratio_pos = randf()
		new_resource.position = %SpawnPoint1.position * ratio_pos + %SpawnPoint2.position *(1-ratio_pos)
		new_resource.rotate(-PI/4+PI/2*randf())
		new_resource.gravity_scale = 1
		new_resource.visible = true
		%Inside.add_child(new_resource)
		total_value += 5
		$TotalValueLabel.text = str(total_value)
		await get_tree().create_timer(spawn_interval).timeout
	for i in range(amount):
		var new_resource:RigidBody2D = sample_res.duplicate()
		new_resource.get_child(1).modulate = resourceColor
		var ratio_pos = randf()
		new_resource.position = %SpawnPoint1.position * ratio_pos + %SpawnPoint2.position *(1-ratio_pos)
		new_resource.rotate(2*PI*randf())
		new_resource.gravity_scale = 1
		new_resource.visible = true
		%Inside.add_child(new_resource)
		total_value += 1
		$TotalValueLabel.text = str(total_value)
		await get_tree().create_timer(spawn_interval).timeout


func _on_sample_resource_tree_exiting(value:int) -> void:
	total_value -= value
	$TotalValueLabel.text = str(total_value)


func _on_remove_pressed() -> void:
	remove_resources(randi_range(0,4))

func remove_resources(value):
	for i in range(min(value, total_value)):
		var res_to_remove : RigidBody2D = %Inside.get_child(%Inside.get_child_count()-i-1)
		res_to_remove.gravity_scale = -1
		res_to_remove.apply_force(Vector2())
		await get_tree().create_timer(0.1).timeout
	
