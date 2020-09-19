extends Node2D

var dreadNought = preload("res://games/FlowerLab/Scenes/Dreadnought.tscn")

var _target_scale = Vector2(1,1)

func _ready():
	pass

var _current = null

func _physics_process(_delta):
	if _current!=null:
		_current.scale = lerp(_current.scale,_target_scale,0.1)

func _on_set_scale(scaleFactor):
	_target_scale=Vector2(1,1)*scaleFactor

func _on_spawn_dreadnought(place):
	if get_child_count()!=0:
		push_warning("tried to spawn two dreadnoughts")
		return
	var new_dreadnought = dreadNought.instance()
	add_child(new_dreadnought)
	_current = new_dreadnought
	new_dreadnought.position = place

func _on_delete():
	for node in get_children():
		node.queue_free()

func _on_move_to(place):
	if _current==null:
		push_warning("tried to move unexistent dreadnought")
		return
	
	if typeof(place)== TYPE_VECTOR2:
		_current.set_target_position(place)
	if typeof(place)== TYPE_STRING:
		_current.set_target_position_by_name(place)

func _on_start_lasers():
	if _current!= null:
		_current._laser_sender()

func _on_stop_lasers():
	if _current!=null:
		_current._stop_lasers()

func _on_set_laser_pattern_time(time):
	if _current!=null:
		_current.set_pattern_time(time)

func _on_set_laser_time(time):
	if _current!=null:
		_current.set_laser_time(time)

func _on_set_laser_speed(speed):
	if _current!=null:
		_current.set_laser_speed(speed)

func _on_set_pattern(type,pattern_time,laser_time,speed):
	if _current!=null:
		_current.pattern_selector(type,pattern_time,laser_time,speed)

func _on_set_light_energy(amount):
	if _current!=null:
		_current.set_target_light_energy(amount)

func _on_EventManager_activate_dreadnought_physics(value):
	if _current!=null:
		_current.activate_physics(value)

func _on_set_dreadnought_tension(value):
	if _current!=null:
		_current.set_alpha(value)

