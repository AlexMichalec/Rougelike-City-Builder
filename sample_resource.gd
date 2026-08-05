extends RigidBody2D
@export var value = 1
@export var max_height = 200
signal deleted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gravity_scale != 0 && global_position.y < max_height:
		deleted.emit(value)
		queue_free()




func _on_button_pressed() -> void:
	gravity_scale = -1
	apply_force(Vector2())
