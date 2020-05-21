extends Node2D

var asteroid0 = preload("res://games/FlowerLab/Scenes/Asteroid0.tscn")
export (float,0,1000) var spawnwidth  = 540
export (float,0,1000) var spawnheight = 200

#export var spawnCenterPath: NodePath
#onready var spawnCenter = get_node(spawnCenterPath) as Position2D

onready var spawnCenter = Vector2(0,-spawnheight)
var _spawn_place = 0
var _spawn_array = []

var rng = RandomNumberGenerator.new()

func _ready():
	spawnCenter.x = get_node("../Positions/SpawnCenter").position.x

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


func spawn_randomized_mirrored():
	var new_asteroid_left = asteroid0.instance()
	var new_asteroid_right = asteroid0.instance()
	self.add_child(new_asteroid_left)
	self.add_child(new_asteroid_right)
	
	var rand = rng.randf_range(0,1)
	
	new_asteroid_left.position  = Vector2(\
	spawnCenter.x - rand*spawnwidth,\
	-spawnheight)
	
	new_asteroid_right.position  = Vector2(\
	spawnCenter.x + rand*spawnwidth,\
	-spawnheight)
	
	new_asteroid_left.linear_velocity = get_spawn_velocity()
	new_asteroid_right.linear_velocity = get_spawn_velocity()

func spawn_randomized():
	var new_asteroid = asteroid0.instance()
	self.add_child(new_asteroid)
	
	new_asteroid.position = get_spawn_point()
	new_asteroid.linear_velocity = get_spawn_velocity()

func spawn_in(place):
	var new_asteroid = asteroid0.instance()
	self.add_child(new_asteroid)
	
	new_asteroid.position =\
	Vector2(spawnCenter.x+place,-spawnheight)
	new_asteroid.linear_velocity = get_spawn_velocity()

func get_spawn_point():
	 return Vector2(\
	spawnCenter.x + rng.randf_range(-1,1)*spawnwidth,\
	-spawnheight)

export (float, 0 , 2000,100) var downward_asteroid_speed = 300

func get_spawn_velocity():
	return Vector2(0, downward_asteroid_speed)

func _on_Timer_timeout():
	spawn_manager()

func _stop():
	$Timer.stop()

func _start():
	spawn_manager()

export (float,0,2,0.1) var time_between_randomized_mirrored = 0.7
export (float,0,2,0.1) var time_between_randomized_normal   = 0.3
export (float,0,2,0.1) var time_between_placed_normal     = 0.3
export (float,0,2,0.1) var time_between_placed_simetric   = 0.6

func _on_EventManager_normal_random_asteroids():
	_pattern_change(spawn_mode.randomized,
	time_between_randomized_normal)

func _on_EventManager_simetric_random_asteroids():
	_pattern_change(\
	spawn_mode.randomized_mirrored,\
	time_between_randomized_mirrored)

func _on_EventManager_place_asteroids(place):
	_pattern_change(spawn_mode.placed,\
	null,\
	place)

func _on_EventManager_array_placed_asteroids(array,time):
	_set_spawn_array(array)
	_pattern_change(spawn_mode.array,time)


func _on_EventManager_simetric_placed_asteroids(place):
	_pattern_change(spawn_mode.placed_mirrored,\
	null,\
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
