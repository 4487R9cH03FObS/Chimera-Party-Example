extends RigidBody2D

const max_distance = 2000

func _process(delta):
	if position.length()>max_distance:
		_die()

func _die():
	get_parent().remove_child(self)
