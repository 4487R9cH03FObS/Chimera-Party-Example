extends Node2D

#export (float, 0.01, 10) var _speed = 1
var _direction = Vector2(0,1)
var _speed = 200
var _scale = Vector2(0,0)
var _max_scale = sqrt(2)*0.5

const max_distance = 1000

func _ready():
	scale=_scale

func _process(_delta):
	if position.length()>max_distance:
		queue_free()

func init(direction,speed=null):
	if direction!=Vector2():
		_direction = direction.normalized()
		rotation = _direction.angle()
	else:
		push_warning("zero vector directions")
	if speed!= null:
		_speed = speed
	

func _physics_process(delta):
	_advance(delta)
	 
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("_take_damage"):
			body._take_damage(_chip_damage*delta)
	_scale.x += delta
	_scale.y += delta
	scale = _scale.clamped(_max_scale) 

var _chip_damage = 80

func _advance(delta):
	position += delta*_speed*_direction
