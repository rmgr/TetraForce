extends Entity

class_name Enemy

func _ready() -> void:
	add_to_group("enemy")
	set_collision_layer_bit(0, 0)
	set_collision_mask_bit(0, 0)
	set_collision_layer_bit(1, 1)
	set_collision_mask_bit(1, 1)
	
	connect("hitstun_end", self, "check_for_death")

func check_for_death() -> void:
	print("checking for death ", health)
	if health == 0:
		rpc("enemy_death")

func get_closest_player():
	var closest_player = null
	for x in room.entities:
		if (x != null):
			if x.get("TYPE") == "PLAYER":
				if closest_player == null:
					closest_player = x
				else:
					if position.distance_to(x.position) < position.distance_to(closest_player.position):
						closest_player = x
		
	return closest_player
