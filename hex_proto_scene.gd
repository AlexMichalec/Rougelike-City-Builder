extends Control
@onready var tile_map_layer = $TextureButton/HexesPrototype
var counter = 0
var prev_coordinates = Vector2i()
var prev_tile = Vector2i(-1,-1)
var build_mode_on = false
var mouse_moved = true
const READY_TO_BUILD_TILE = Vector2i(5,3)
const HOVER_TILE = Vector2i(6,6)
const HOVER_TO_BUILD = Vector2i(1,0)

const BASIC_DESSERT = Vector2i(2,3)
signal building_finished
signal building_started
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	var test = generate(9)
	for i in range(test.size()):
		tile_map_layer.set_cell(test[i],0,READY_TO_BUILD_TILE)
	#for i in range(10):
		#for j in range(10):
			#tile_map_layer.set_cell(Vector2i(i, j),0,Vector2i(4,13))
			#await get_tree().create_timer(0.2).timeout


func _process(delta: float) -> void:
	#counter+=delta
	var coordinates = tile_map_layer.local_to_map(tile_map_layer.to_local(get_local_mouse_position()))
	if coordinates != prev_coordinates:
		if tile_map_layer.get_cell_source_id(coordinates) ==1:
			return
		if !mouse_moved:
			prev_tile = HOVER_TO_BUILD
			build_mode_on = false
		mouse_moved = true
		if prev_tile!= Vector2i(-1,-1):
			tile_map_layer.set_cell(prev_coordinates,0,prev_tile)
		prev_tile = tile_map_layer.get_cell_atlas_coords(coordinates)
		prev_coordinates = coordinates
		if prev_tile == READY_TO_BUILD_TILE:
			tile_map_layer.set_cell(coordinates,0,HOVER_TILE if not build_mode_on  else HOVER_TO_BUILD)
		

	if counter > 1:
		counter = 0
		tile_map_layer.set_cell(Vector2i(randi_range(0,4), randi_range(0, 4)),0,Vector2i(randi_range(0,5),randi_range(0,5)))

func generate(goal_size:int):
	var result = []
	var potentials = [Vector2i(0,1)]
	while (result.size() < goal_size):
		potentials.shuffle()
		var new_hex = potentials[0]
		while new_hex in result:
			potentials.pop_front()
			new_hex = potentials[0]
		potentials.pop_front()
		for x in [[-1,0],[1,0],[0,-1],[0,1],[-1,1],[1,-1]]:
			var new_vector = Vector2i(new_hex[0]+x[0],new_hex[1]+x[1])
			if !(new_vector in result):
				potentials.append(new_vector)
		result.append(new_hex)
	return result
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ChooseTile"):
		if !build_mode_on:
			return
		mouse_moved = false
		var coordinates = tile_map_layer.local_to_map(tile_map_layer.to_local(event.position))
		if tile_map_layer.get_cell_source_id(coordinates) == -1:
			return
		if tile_map_layer.get_cell_atlas_coords(coordinates) != HOVER_TO_BUILD:
			return
		var new_building_tile = Vector2i(randi_range(7,10),randi_range(0,4))
		building_started.emit()
		Global.chosen_coords = coordinates
		await  get_tree().create_timer(0.75).timeout
		
		tile_map_layer.set_cell(coordinates,1,Vector2i(0,0))
		
		if not mouse_moved:
			prev_tile = Vector2i(-1,-1)
			
		mouse_moved = true
		build_mode_on = false
		building_finished.emit()
		

		
		
		
