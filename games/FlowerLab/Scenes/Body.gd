extends RigidBody2D

const max_distance = 2000


func _process(_delta):
	if position.length()>max_distance:
		_really_die()

func _die():
	emit_signal("has_died")
	$real_death_timer.wait_time = 0.01
	$real_death_timer.start()

func _really_die():
	get_parent().remove_child(self)

## Health
export (float) var _max_health    = 100
onready var _health = _max_health
signal health_updated(health)
signal has_died
signal took_damage

## inside Damages
export (float,0,100,5)   var chip_damage_collision = 100/4
export (float,0,100,0.1) var bound_on_external_damage = 100

## outside damages
var damage_potential = 5
var rebote = 10

func _take_damage(value):
	_set_health(_health-value)
	emit_signal("took_damage",value)

func _set_health(value):
	var prev_health = _health
	_health = clamp(value,0,_max_health)
	if _health!= prev_health:
		emit_signal("health_updated",_health)
		if _health <= 0:
			_die()

func _on_Body_body_entered(body):
	
	# against rigidbody
	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
		_take_damage(25)
	
	
	#various cases
#	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
#		var relative_velocity = self.linear_velocity - body.linear_velocity
#		var damage =\
#		chip_damage_collision +\
#		body.damage_potential* relative_velocity.length()
#		damage = clamp(damage,0,bound_on_external_damage)
#		_take_damage(damage)
#		if "rebote" in body:
#			apply_central_impulse(-relative_velocity*(rebote+body.rebote))
#		else:
#			apply_central_impulse(-relative_velocity*rebote)

