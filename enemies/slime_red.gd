extends Enemy

class_name slime_red
var movetimer_length: int = 100
var movetimer: int = 0

func _ready() -> void:
	puppet_pos = position
	
	anim.play("default")
	movedir = entity_helper.rand_direction()

func _physics_process(delta: float) -> void:
	if !is_scene_owner() || is_dead():
		return
	
	loop_movement()
	loop_damage()
	
	if movetimer > 0:
		movetimer -= 1
	if (movetimer > 20 && movetimer < 70):
		movedir = Vector2(0,0)
	if (movetimer == 0):
		movedir = entity_helper.rand_direction()
		movetimer = movetimer_length
	

func puppet_update() -> void:
	position = puppet_pos

func _process(delta: float) -> void:
	loop_network()
	
sync func enemy_death() -> void:
	if is_scene_owner():
		var x = preload("res://enemies/slime_green.tscn").instance()
		room.add_entity(x)
		choose_subitem(["HEALTH", "RUPEE"], 100)
	room.remove_entity(self)
	var death_animation = preload("res://enemies/enemy_death.tscn").instance()
	death_animation.global_position = global_position
	get_parent().add_child(death_animation)
	set_dead()
