extends Node2D

var asteroid1 = preload("res://games/FlowerLab/Scenes/Asteroids/1.tscn")
var asteroid2 = preload("res://games/FlowerLab/Scenes/Asteroids/2.tscn")
var asteroid3 = preload("res://games/FlowerLab/Scenes/Asteroids/3.tscn")
var asteroid4 = preload("res://games/FlowerLab/Scenes/Asteroids/4.tscn")
var asteroid5 = preload("res://games/FlowerLab/Scenes/Asteroids/5.tscn")
var asteroid6 = preload("res://games/FlowerLab/Scenes/Asteroids/6.tscn")
var asteroid7 = preload("res://games/FlowerLab/Scenes/Asteroids/7.tscn")
var asteroid8 = preload("res://games/FlowerLab/Scenes/Asteroids/8.tscn")
var asteroid9 = preload("res://games/FlowerLab/Scenes/Asteroids/9.tscn")
var asteroid10 = preload("res://games/FlowerLab/Scenes/Asteroids/10.tscn")
var asteroid11 = preload("res://games/FlowerLab/Scenes/Asteroids/11.tscn")
var asteroid12 = preload("res://games/FlowerLab/Scenes/Asteroids/12.tscn")
var asteroid13 = preload("res://games/FlowerLab/Scenes/Asteroids/13.tscn")

var asteroids =[\
asteroid1,\
asteroid2,\
asteroid3,\
asteroid4,\
asteroid5,\
asteroid6,\
asteroid7,\
asteroid8,\
asteroid9,\
asteroid10,\
asteroid11,\
asteroid12,\
asteroid13]

export (float,0,1000) var spawnwidth  = 800
export (float,0,1000) var spawnheight = 200

#export var spawnCenterPath: NodePath
#onready var spawnCenter = get_node(spawnCenterPath) as Position2D

onready var spawnCenter = Vector2(0,-spawnheight)
var _spawn_place = 0
var _spawn_array = []

var rng = RandomNumberGenerator.new()

func _ready():
	spawnCenter.x = get_node("../Positions/SpawnCenter").position.x
	rng.randomize()

enum spawn_mode\
{randomized,\
randomized_mirrored,\
placed,\
placed_mirrored,\
array}

var _current_spawn_mode = null
onready var _time_between_spawns = $Timer.wait_time

func spawn_manager():
	if _current_spawn_mode == null:
		print("stopped spawning")
		return
	
	$Timer.wait_time = _time_between_spawns
	
	match _current_spawn_mode:
		spawn_mode.randomized:
			spawn_randomized()
		spawn_mode.randomized_mirrored:
			spawn_randomized_mirrored()
		spawn_mode.placed:
			spawn_in(_spawn_place)
		spawn_mode.placed_mirrored:
			spawn_in(_spawn_place)
			spawn_in(-_spawn_place)
		spawn_mode.array:
			for place in _spawn_array:
				spawn_in(place)
	$Timer.start()

onready var n_asteroids = asteroids.size()
func _new_instance():
	var i = rng.randi_range(0,n_asteroids-1)
	var new_instance = asteroids[i].instance()
	self.add_child(new_instance)
	return new_instance

func spawn_randomized_mirrored():
	var new_asteroid_left = _new_instance()
	var new_asteroid_right = _new_instance()
#	self.add_child(new_asteroid_left)
#	self.add_child(new_asteroid_right)
	
	var rand = rng.randf_range(0,1)
	
	new_asteroid_left.position = Vector2(\
	spawnCenter.x - rand*spawnwidth,\
	-spawnheight)
	
	new_asteroid_right.position  = Vector2(\
	spawnCenter.x + rand*spawnwidth,\
	-spawnheight)
	
	new_asteroid_left.linear_velocity = get_spawn_velocity()
	new_asteroid_right.linear_velocity = get_spawn_velocity()
	new_asteroid_left.angular_velocity = get_spawn_angular_velocity()
	new_asteroid_right.angular_velocity = get_spawn_angular_velocity()

func spawn_randomized():
	var new_asteroid = _new_instance()
#	self.add_child(new_asteroid)
	
	new_asteroid.position = get_spawn_point()
	new_asteroid.linear_velocity = get_spawn_velocity()

func spawn_in(place):
	var new_asteroid = _new_instance()
#	self.add_child(new_asteroid)
	new_asteroid.position =\
	Vector2(spawnCenter.x+place,-spawnheight)
	new_asteroid.linear_velocity = get_spawn_velocity()
	new_asteroid.angular_velocity = get_spawn_angular_velocity()
	var brightness = rng.randf_range(0.8,1)
	new_asteroid.set_value(brightness)

func get_spawn_point():
	 return Vector2(\
	spawnCenter.x + rng.randf_range(-1,1)*spawnwidth,\
	-spawnheight)

var downward_asteroid_speed = 300

func set_asteroid_speed(speed):
	downward_asteroid_speed = speed

func get_spawn_velocity():
	return Vector2(0, downward_asteroid_speed)

export (float ,0, 20) var angular_max = 4

func get_spawn_angular_velocity():
	return rng.randf_range(-angular_max,angular_max)

func _on_Timer_timeout():
	spawn_manager()

func _stop():
	$Timer.stop()

func _start():
	spawn_manager()

func _on_EventManager_normal_random_asteroids(time):
	_pattern_change(spawn_mode.randomized,
	time)

func _on_EventManager_simetric_random_asteroids(time):
	_pattern_change(\
	spawn_mode.randomized_mirrored,\
	time)

func _on_EventManager_place_asteroids(place,time):
	_pattern_change(spawn_mode.placed,\
	time,\
	place)

func _on_EventManager_array_placed_asteroids(array,time):
	_set_spawn_array(array)
	_pattern_change(spawn_mode.array,time)

func _on_EventManager_simetric_placed_asteroids(place,time):
	_pattern_change(spawn_mode.placed_mirrored,\
	time,\
	place)

func _pattern_change(mode,time_interval=null,place=null):
	_stop()
	if mode!=null:
		_set_mode(mode)
	if time_interval!=null:
		_set_time_interval(time_interval)
	if place!=null:
		_set_place(place)
	spawn_manager()

func _set_place(place):
	if place!=null:
		_spawn_place = place

func _set_mode(mode):
	_current_spawn_mode = mode

func _set_time_interval(time_interval):
	_time_between_spawns = time_interval

func _set_spawn_array(array):
	_spawn_array = array

func _on_EventManager_halt_asteroids():
	_stop()

func _on_EventManager_restart_asteroids():
	_start()

func _on_EventManager_set_asteroid_speed(speed):
	set_asteroid_speed(speed)
