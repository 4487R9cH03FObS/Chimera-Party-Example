extends RigidBody2D

export var SPEED: float = 500
var linear_vel = Vector2()

var player_index
var player_color

# Inputs
var move_left = ""
var move_right = ""
var move_up = ""
var move_down = ""
var action_a = ""
var action_b = ""

## Initial settings

onready var soundManager=get_parent().get_parent().get_node("SoundManager")
func _ready():
	self.connect("sfx_request",soundManager,"_on_sfx_request")
	linear_damp = damp

func init(player_index, player_color):
	self.player_index = player_index
	self.player_color = player_color
	$Sprite.modulate = Party.available_colors[player_color]
	var spi = str(player_index)
	move_left = "move_left_" + spi
	move_right = "move_right_" + spi
	move_up = "move_up_" + spi
	move_down = "move_down_" + spi
	action_a = "action_a_" + spi
	action_b = "action_b_" + spi

## Main Processes

func _physics_process(delta):
	get_target_acceleration()
	apply_central_impulse(target_acceleration*delta)
	if linear_velocity.length()>max_speed:
		linear_velocity=linear_velocity.normalized()*max_speed
	
	if Input.is_action_pressed(move_left) and not Input.is_action_pressed(move_right):
		$Sprite.flip_h = true
	if Input.is_action_pressed(move_right) and not Input.is_action_pressed(move_left):
		$Sprite.flip_h = false
	
	if Input.is_action_just_pressed(action_a):
		$Sprite.flip_v = !$Sprite.flip_v
	
	if _is_out_of_bounds():
		die()

### Physics

export (int) var max_speed = 550
export (float,0,1,0.1) var damp = 5
export (float,0,1,0.1) var weightness = 1
var top_acceleration = 5000
var target_acceleration = Vector2()
var _ddx = Vector2()
var _dx  = Vector2()
var _d_multiplier = 0
var epsilon = 0.01

func get_target_acceleration():
	_ddx = Vector2()
	if _dx.length()<epsilon:
		_d_multiplier = 1
	else:
		_d_multiplier = pow(_dx.length(),-1/2)
	if Input.is_action_pressed(move_left):
		_ddx.x=-1
	if Input.is_action_pressed(move_right):
		_ddx.x=1
	if Input.is_action_pressed(move_up):
		_ddx.y=-1
	if Input.is_action_pressed(move_down):
		_ddx.y=1
	_dx.x += _d_multiplier*_ddx.x 
	_dx.y += _d_multiplier*_ddx.y 
	target_acceleration = _dx*top_acceleration
	_dx = lerp(_dx,Vector2(),weightness)
	pass

### Health Damage and death management

export (float) var _max_health    = 100
onready var _health = _max_health
signal health_updated(health)
#### Health

func _set_health(value):
	var prev_health = _health
	_health = clamp(value,0,_max_health)
	if _health!= prev_health:
		emit_signal("health_updated",_health)
		if _health <= 0:
			die()

#### Damage
signal killed
export (float,0,100,5)   var chip_damage_collision = 10
export (float,0,100,0.1) var bound_on_external_damage = 70
var damage_potential = 10
var rebote  = 10

func _take_damage(value):
	_set_health(_health-value)
	emit_signal("took_damage",value)

func _on_Player_body_entered(body):
	
	print(body.get_class())
	#various cases
	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
		var relative_velocity = self.linear_velocity - body.linear_velocity
		var damage =\
		chip_damage_collision +\
		body.damage_potential* relative_velocity.length()
		damage = clamp(damage,0,bound_on_external_damage)
		_sound_emiter(sound.collision,damage)
		_take_damage(damage)
		print(self.get_name() + "suffered: " + str(damage))
		if "player_color" in body:
			apply_central_impulse(-relative_velocity*rebote)
		else: 
			apply_central_impulse(linear_velocity*rebote)


#### Death
signal took_damage

var lower_bounds  = Vector2(0,0)
var upper_bounds  = Vector2(1920,1080)

func die():
	print("player" + str(player_index) + " is ded ")

func _is_out_of_bounds():
	return !\
	(position.x>=lower_bounds.x) and (position.x<=upper_bounds.x) and\
	(position.y>=lower_bounds.y) and (position.y<=upper_bounds.y)

## Sound
signal sfx_request

export (float,0,100,5) var minimum_volume = 90
enum sound {collision}
func _sound_emiter(type,strength):
	# strength tiene distintos valores dependiendo del origen
	# por simplicidad, strength vale de 0 a 100
	var output = minimum_volume+strength*3/10
	match type:
		sound.collision:
			emit_signal("sfx_request",\
			"player_collision",\
			output)
