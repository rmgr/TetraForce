extends Item


var shooter
var timer
puppet var puppet_pos = position

func start():
	
	shooter = get_parent()
	add_to_group("projectile")
	z_index = shooter.z_index - 1
	
	get_parent().remove_child(self)
	shooter.get_parent().add_child(self)
	
	position = shooter.position
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timeout")
	timer.set_wait_time( 2 )
	add_child(timer)
	timer.start()
	set_physics_process(true)
	
func _physics_process(delta):
	return

func body_entered(body):
	if body.get("TYPE") != TYPE:
		delete()

func _on_timeout():
	print_debug("boom")
	delete()

sync func delete():
	queue_free()
