extends Enemy

class_name slime_green
var movetimer_length: int = 100
var movetimer: int = 0
var active: bool = false

func _ready() -> void:
	puppet_pos = position
	$Sprite.visible = false
	
	anim.play("default")
	movedir = entity_helper.rand_direction()

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
	
