extends Enemy

class_name slime_green
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
	
