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
	$Timer.start()
	
	
func spawn_randomized(_type):
	var new_asteroid = asteroid0.instance()
	self.add_child(new_asteroid)
	
	new_asteroid.position = get_spawn_point()
	new_asteroid.linear_velocity = get_spawn_velocity()


func get_spawn_point():
	 return Vector2(\
	spawnCenter.x + rng.randf_range(-1,1)*spawnwidth,\
	-spawnheight)

func get_spawn_velocity():
	return Vector2(0, 200)

func _on_Timer_timeout():
	spawn_randomized("anything")
	$Timer.start()
