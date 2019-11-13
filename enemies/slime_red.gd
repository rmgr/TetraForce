extends Enemy

class_name slime_red
var movetimer_length: int = 100
var movetimer: int = 0
var active: bool = false

func _ready() -> void:
	puppet_pos = position
	$Sprite.visible = false
	anim.play("default")

func _physics_process(delta: float) -> void:
	if !is_scene_owner() || is_dead():
		return
	
	loop_movement()
	loop_damage()
	
	if active:
		if movetimer > 0:
			movetimer -= 1
		
		if (movetimer > 20 && movetimer < 80):
			movedir = Vector2(0,0)
			
		if (movetimer == 0):
			var target_position = get_tree().get_nodes_in_group("player")[0].position
			movedir = (target_position - position).normalized()
			movetimer = movetimer_length
	else:
		var target_position = get_tree().get_nodes_in_group("player")[0].position
		var distance = position.distance_to(target_position)
		print_debug(distance)
		if distance <= 50:
			active = true
			$Sprite.visible = true
			movedir = (target_position - position).normalized()

func puppet_update() -> void:
	position = puppet_pos

func _process(delta: float) -> void:
	loop_network()
	
sync func enemy_death() -> void:
	if is_scene_owner():
		var number_of_children = randi() % 3 + 1
		for i in range(number_of_children):
			var child_slime = preload("res://enemies/slime_green.tscn").instance()
			child_slime.position = position + Vector2(randi() % 3 + 1,randi() % 3 + 1)
			get_parent().add_child(child_slime)
			room.add_entity(child_slime)
			
	room.remove_entity(self)
	var death_animation = preload("res://enemies/enemy_death.tscn").instance()
	death_animation.global_position = global_position
	get_parent().add_child(death_animation)
	set_dead()
