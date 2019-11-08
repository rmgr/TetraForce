extends StaticBody2D

export var is_blasted = false
export var sprite_loc = "res://tiles/cliff.png"

func _ready() -> void:
	set_process(true)
	set_physics_process(true)
	is_blasted = false
	visible = true
	set_collision_layer_bit(0,1)
	set_collision_layer_bit(1,1)
	connect("body_entered", self, "body_entered")
	$Sprite.texture = load(sprite_loc)
	
func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	pass


func blast():
	is_blasted = true
	# Do fancy animation or something, then make door inactive
	visible = false
	set_collision_layer_bit(0,0)
	set_collision_layer_bit(1,0)
