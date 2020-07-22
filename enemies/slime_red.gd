extends Enemy

class_name slime_red
var movetimer_length: int = 100
var movetimer: int = 0
var active: bool = false
var number_of_children
func _ready() -> void:
	puppet_pos = position
	$Sprite.visible = false
	number_of_children = randi() % 3 + 1
	anim.play("default")

func _physics_process(delta: float) -> void:
	if !is_scene_owner() || is_dead():
		return
	
	loop_movement()
	loop_damage()
	
	if active:
		
		rpc("show_slime")
		if movetimer > 0:
			movetimer -= 1
		
		if (movetimer > 20 && movetimer < 80):
			movedir = Vector2(0,0)
			
		if (movetimer == 0):
			var target_position = get_closest_player().position
			movedir = (target_position - position).normalized()
			movetimer = movetimer_length
	else:
		var target_position = get_closest_player().position
		var distance = position.distance_to(target_position)
		print_debug(distance)
		if distance <= 50:
			active = true
			rpc("show_slime")
			movedir = (target_position - position).normalized()

sync func show_slime():
	$Sprite.visible = true
	
func puppet_update() -> void:
	position = puppet_pos

func _process(delta: float) -> void:
	loop_network()
	
sync func spawn_child_slimes() -> void:
	for i in range(number_of_children + 1):
		var subitem_name: String = str(randi()) # we need to sync names to ensure the subitem can rpc to the same thing for others
		network.current_map.spawn_subitem("res://enemies/slime_green.tscn", global_position, subitem_name) 
	
sync func enemy_death() -> void:
	if is_scene_owner():
		
		rpc("spawn_child_slimes")
		
	room.remove_entity(self)
	var death_animation = preload("res://enemies/enemy_death.tscn").instance()
	death_animation.global_position = global_position
	get_parent().add_child(death_animation)
	set_dead()
