extends KinematicBody2D

onready var players_node = get_parent().get_parent().get_node("Players")
## get on instancing

var laser= preload("res://games/FlowerLab/Scenes/Laser.tscn")
#var bullet= preload("res://games/FlowerLab/Scenes/Laser.tscn")
onready var phase_timer = $PhaseTimer
onready var laser_timer = $LaserTimer
onready var pattern_timer = $PatternTimer
onready var light = $Light2D

func _ready():
	pass

func init():
	pass

var _d_dtposition = Vector2() 
var alpha = 10

var _target_light = 1

func set_target_light_energy(amount):
	_target_light = amount

func _physics_process(_delta):
	# solve dposition/dt = alpha*(target_position-position) , alpha>0
	_d_dtposition = alpha*(_target_position-position)
	_d_dtposition = move_and_slide(_d_dtposition)
	
	light.energy = lerp(light.energy,_target_light,0.05)

onready var _target_position = position

func set_target_position(target):
	_target_position = target
	pass

func set_target_position_by_name(name):
	var target_position = null
	match name:
		"center":
			var vp_size = get_viewport().get_rect().size
			target_position = vp_size/2
			pass
		"top":
			pass
		"dissapear_top":
			pass
	if target_position!= null:
		set_target_position(target_position)

func _on_Area2D_body_entered(body):
	# against rigidbody
	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
		if body.has_method("_take_damage"):
			body._take_damage(100)
			# emit awful sound and light

func _get_players_positions():
	var positions = []
	for node in players_node.get_children():
		positions.push_back(node.position)
	return positions

func _get_players_directions():
	var directions = []
	for node in players_node.get_children():
		directions.push_back(node.position-position)
	return directions

func _get_nearest_player_position():
	var positions = _get_players_positions()
	var nearest = Vector2(10000,10000)
	for pos in positions:
		if (position-pos).length()<(position-nearest).length():
			nearest = pos
	return nearest

func _get_farthest_player_direction():
	var positions = _get_players_positions()
	var nearest = position
	for pos in positions:
		if (position-pos).length()>(position-nearest).length():
			nearest = pos
	return nearest-position


func _get_nearest_player_direction():
	return _get_nearest_player_position()-position
## laser manager

var _laser_speed = 200
onready var _current_launch_direction = Vector2(0,1)
#_get_nearest_player_position()-position
var _current_laser_pattern_type = laser_pattern.everyone
enum laser_pattern {nearest,everyone,farthest,type1,type2,type3,type4}

func set_pattern_time(time):
	pattern_timer.wait_time=time
func set_laser_time(time):
	laser_timer.wait_time=time
func set_laser_speed(speed):
	_laser_speed = speed

func pattern_selector(\
type_enum,\
time_between_patterns,\
time_between_lasers,\
laser_speed=null):
	
	_current_laser_pattern_type = _get_enum_laser_type(type_enum)
	pattern_timer.wait_time = time_between_patterns
	laser_timer.wait_time = time_between_lasers
	
	if laser_speed!= null:
		_laser_speed=laser_speed

func _get_enum_laser_type(name):
	match name:
		"nearest":
			return laser_pattern.nearest
		"everyone":
			return laser_pattern.everyone
		"farthest":
			return laser_pattern.farthest
		"type1":
			return laser_pattern.type1
		"type2":
			return laser_pattern.type2
		"type3":
			return laser_pattern.type3
		"type4":
			return laser_pattern.type4

func _laser_sender():
	laser_timer.stop()
#	$LaserTimer.stop()
	match _current_laser_pattern_type:
		laser_pattern.nearest:
			_current_launch_direction = _get_nearest_player_direction()
			_send_laser()
		laser_pattern.everyone:
			for dir in _get_players_directions():
				_current_launch_direction = dir
				_send_laser()
		laser_pattern.farthest:
			_current_launch_direction = _get_farthest_player_direction()
			_send_laser()
#			laser_timer.start()
		laser_pattern.type1:
			_pattern_1()
#			laser_timer.start()
		laser_pattern.type2:
			_pattern_2()
#			laser_timer.start()
		laser_pattern.type3:
			_pattern_3()
#			laser_timer.start()
	laser_timer.start()
	pattern_timer.start()

var rng = RandomNumberGenerator.new()

func _pattern_1():
	_current_launch_direction = Vector2.DOWN+Vector2.RIGHT
	_send_laser()
	_current_launch_direction = Vector2.DOWN+Vector2.LEFT
	_send_laser()
	_current_launch_direction = Vector2.UP+Vector2.RIGHT
	_send_laser()
	_current_launch_direction = Vector2.UP+Vector2.LEFT
	_send_laser()

var t_laser = 0
func _pattern_2():
	var direction = Vector2(cos(t_laser),sin(t_laser))
	_current_launch_direction = direction
	_send_laser()
	t_laser+=2*PI*(laser_timer.wait_time/pattern_timer.wait_time)
	pass

func _pattern_3():
	var directions = _get_players_directions()
	var rand = rng.randf_range(-100,100)
	for dir in directions:
		_current_launch_direction = dir + Vector2(-rand,rand)
		_send_laser()
		_current_launch_direction = dir + Vector2(rand,-rand)
		_send_laser()
		_current_launch_direction = dir
		_send_laser()

func _pattern_4():
	_current_launch_direction = Vector2.DOWN
	_send_laser()
	_current_launch_direction = Vector2.LEFT
	_send_laser()
	_current_launch_direction = Vector2.UP
	_send_laser()
	_current_launch_direction = Vector2.RIGHT
	_send_laser()

func _stop_lasers():
	laser_timer.stop()
	pattern_timer.stop()

func _re_start_lasers():
	_laser_sender()

func _send_laser():
	var new_laser = laser.instance()
	add_child(new_laser)
	new_laser.init(_current_launch_direction,_laser_speed)

func _send_laser_pattern():
	_launch_current_pattern()
	laser_timer.start()

func _launch_current_pattern():
	match _current_laser_pattern_type:
		laser_pattern.type1:
			_pattern_1()
		laser_pattern.type2:
			_pattern_2()
		laser_pattern.type3:
			_pattern_3()
		laser_pattern.type4:
			_pattern_4()
