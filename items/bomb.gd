extends Item


var shooter
var timer
var exploded
var blasted_walls

puppet var puppet_pos = position

func start():
	TYPE = "TRAP"
	DAMAGE = 0
	blasted_walls = []
	shooter = get_parent()
	add_to_group("projectile")
	z_index = shooter.z_index + 1
	exploded = false
	get_parent().remove_child(self)
	shooter.get_parent().add_child(self)
	position = shooter.position
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timeout")
	timer.set_wait_time( 2 )
	add_child(timer)
	timer.start()
	set_physics_process(true)
	
	$Hitbox.connect("body_entered", self, "body_entered")
		

func _physics_process(delta: float) -> void:
	pass
	
func body_entered(body):
	if !exploded:
		blasted_walls.push_back(body)
	

func _on_timeout():
	timer.stop()
	exploded = true
	DAMAGE = 2
	for body in blasted_walls:
		if body.has_method("blast"):
			body.blast()
	var death_animation = preload("res://enemies/enemy_death.tscn").instance()
	death_animation.global_position = global_position
	get_parent().add_child(death_animation)
	$Sprite.visible = false
	print_debug("boom - play animation here")
	var timer2 = Timer.new()
	timer2.connect("timeout", self, "delete")
	timer2.set_wait_time( 0.25 )
	add_child(timer2)
	timer2.start()
	
sync func delete():
	queue_free()
