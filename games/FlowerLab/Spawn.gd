extends Node2D

var asteroid0 = preload("res://games/FlowerLab/Scenes/Asteroid0.tscn")
export (float,0,1000) var spawnwidth  = 540
export (float,0,1000) var spawnheight = 200

#export var spawnCenterPath: NodePath
#onready var spawnCenter = get_node(spawnCenterPath) as Position2D

onready var spawnCenter = Vector2(0,-spawnheight)

var rng = RandomNumberGenerator.new()

func _ready():
	spawnCenter.x = get_node("../Positions/SpawnCenter").position.x

enum spawn_mode {randomized, randomized_mirrored, dreadnaught}
var current_spawn_mode = null
onready var time_between_spawns = $Timer.wait_time

func spawn_manager():
	if current_spawn_mode == null:
		print("stopped spawning")
		return
	
	$Timer.wait_time = time_between_spawns
	
	match current_spawn_mode:
		spawn_mode.randomized:
			spawn_randomized()
			$Timer.start()
		spawn_mode.randomized_mirrored:
			spawn_randomized_mirrored()
			$Timer.start()
		spawn_mode.dreadnaught:
			spawn_in(-400)
			
	pass

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

export (float,0,2,0.1) var time_between_randomized_mirrored = 0.8
export (float,0,2,0.1) var time_between_randomized_normal   = 0.4

func _on_EventManager_normal_random_asteroids():
	_stop()
	current_spawn_mode = spawn_mode.randomized
	time_between_spawns = time_between_randomized_normal
	spawn_manager()
	pass # Replace with function body.

func _on_EventManager_simetric_random_asteroids():
	_stop()
	current_spawn_mode = spawn_mode.randomized_mirrored
	time_between_spawns = time_between_randomized_mirrored
	spawn_manager()
