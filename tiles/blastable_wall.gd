tool
extends StaticBody2D


export var is_blasted = false
export var sprite = "res://tiles/cliff.png"
export var patch_dir = "lr"
var tiles_to_patch
var all_set = false
var parent 
func _ready() -> void:
	tiles_to_patch = {"left": -1, "right" : -1, "up" : -1, "down" : -1}
	set_process(true)
	set_physics_process(true)
	is_blasted = false
	visible = true
	set_collision_layer_bit(0,1)
	set_collision_layer_bit(1,1)
	parent = get_parent()
	connect("body_entered", self, "body_entered")
	var l = load("res://tiled/overworld/overworld_walls.tsx")
	

func _physics_process(delta):
	if !all_set:
		if parent != null:
			var wall_tilemap = parent.get_node("walls")
			var tile_pos = wall_tilemap.world_to_map(position)
			var this_tile = wall_tilemap.get_cellv(tile_pos)
			if ("l" in patch_dir):
				var left_tile = Vector2(tile_pos.x - 1, tile_pos.y)
				tiles_to_patch["left"] = wall_tilemap.get_cellv(left_tile)
				wall_tilemap.set_cellv(left_tile, this_tile)
				
			if ("r" in patch_dir):
				var right_tile = Vector2(tile_pos.x + 1, tile_pos.y)
				tiles_to_patch["right"] = wall_tilemap.get_cellv(right_tile)
				wall_tilemap.set_cellv(right_tile, this_tile)
			
			all_set = true
	
func blast():
	is_blasted = true
	# Do fancy animation or something, then make door inactive
	var wall_tilemap = parent.get_node("walls")
	var tile_pos = wall_tilemap.world_to_map(position)
	wall_tilemap.set_cellv(tile_pos, -1)
	
	if ("l" in patch_dir):
		var left_tile = Vector2(tile_pos.x - 1, tile_pos.y)
		wall_tilemap.set_cellv(left_tile, tiles_to_patch["left"] )
		
	if ("r" in patch_dir):
		var right_tile = Vector2(tile_pos.x + 1, tile_pos.y)
		wall_tilemap.set_cellv(right_tile, tiles_to_patch["right"])
	
	visible = false
	set_collision_layer_bit(0,0)
	set_collision_layer_bit(1,0)
