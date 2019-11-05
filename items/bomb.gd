extends Item


var shooter
var timer
var exploded
var affectedBodies
puppet var puppet_pos = position

func start():
	exploded = false
	DAMAGE *= 4
	TYPE = "TRAP"
	shooter = get_parent()
	add_to_group("projectile")
	z_index = shooter.z_index - 1
	
	get_parent().remove_child(self)
	shooter.get_parent().add_child(self)
	#$Hitbox.connect("body_entered", self, "body_entered")
	position = shooter.position
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timeout")
	timer.set_wait_time( 2 )
	add_child(timer)
	timer.start()
	set_physics_process(true)
	
func _physics_process(delta):
	return


func _on_timeout():
	timer.stop()
	$Hitbox/CollisionShape2D.disabled = false
	print_debug("boom")
	exploded = true
	var timer2 = Timer.new()
	timer2.connect("timeout", self, "delete")
	timer2.set_wait_time( 1 )
	add_child(timer2)
	timer2.start()
	
	

sync func delete():
	queue_free()
