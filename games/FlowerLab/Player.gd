extends RigidBody2D

export var SPEED: float = 500
var linear_vel = Vector2()

var player_index
var player_color

# Inputs
var move_left  = ""
var move_right = ""
var move_up    = ""
var move_down  = ""
var action_a   = ""
var action_b   = ""

## Initial settings

onready var main = get_parent().get_parent()
onready var soundManager= main.get_node("SoundManager")
onready var GUI = main.get_node("GUI")

func _ready():
# warning-ignore:return_value_discarded
	self.connect("sfx_request",soundManager,"_on_sfx_request")
# warning-ignore:return_value_discarded
	self.connect("score_growth",main,"_on_player_score_growth")
# warning-ignore:return_value_discarded
	self.connect("player_died",main,"_on_player_death")
# warning-ignore:return_value_discarded
	self.connect("somewhat_out_of_bounds",GUI,"_on_pulse")
	
	$TextureProgress.max_value = _max_health
	health_bar.value=_max_health
	linear_damp = damp
	var bound_node = main.get_node(\
	"GUI/MarginContainer/HBoxContainer/VBoxContainer3/gameplay")
	var upleft = bound_node.get_global_position()
	s_lower_bounds = upleft
	s_upper_bounds = upleft + Vector2(\
	bound_node.margin_right,\
	bound_node.margin_bottom-bound_node.margin_top)


# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(player_index, player_color):
	self.player_index = player_index
	self.player_color = player_color
	$Sprite.modulate = Party.available_colors[player_color]
	var spi = str(player_index)
	move_left  = "move_left_" + spi
	move_right = "move_right_" + spi
	move_up    = "move_up_" + spi
	move_down  = "move_down_" + spi
	action_a   = "action_a_" + spi
	action_b   = "action_b_" + spi

## Main Processes

func _physics_process(delta):
	get_target_acceleration()

	if Input.is_action_pressed(action_a):
		apply_central_impulse(target_acceleration*delta*action_acceleration_multiplier)
	else:
		apply_central_impulse(target_acceleration*delta)

	if linear_velocity.length()>max_speed:
		linear_velocity=linear_velocity.normalized()*max_speed
	
	if Input.is_action_pressed(move_left) and not Input.is_action_pressed(move_right):
		$Sprite.flip_h = true
	if Input.is_action_pressed(move_right) and not Input.is_action_pressed(move_left):
		$Sprite.flip_h = false
	
	
	if _is_somewhat_out_of_bounds():
		emit_signal("somewhat_out_of_bounds")
		_take_damage(20*delta)
	
	if _is_out_of_bounds():
		emit_signal("out_of_bounds")
		die()
	
	_score_counter(delta)

### Physics

export var action_acceleration_multiplier = 0.3
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
	_ddx = _ddx.normalized()
	_dx.x += _d_multiplier*_ddx.x 
	_dx.y += _d_multiplier*_ddx.y 
	target_acceleration = _dx*top_acceleration
	_dx = lerp(_dx,Vector2(),weightness)
	pass

### Health Damage and death management

export (float) var _max_health    = 300
onready var _health = _max_health
signal health_updated # float

#### Health

func _set_health(value):
	var prev_health = _health
	_health = clamp(value,0,_max_health)
	if _health!= prev_health:
		emit_signal("health_updated",_health)
		if _health <= 0:
			die()

onready var health_bar   = $TextureProgress
onready var health_tween = $Tween
func _on_health_update(health):
	health_bar.value = health
	
#### Damage
export (float,0,100,5)   var chip_damage_collision = 10
export (float,0,100,0.1) var bound_on_external_damage = 70
signal took_damage
var damage_potential = 10

func _take_damage(value):
	_set_health(_health-value)
	emit_signal("took_damage",value)
	_sound_emiter(sound.chip_damage,70)

var rebote  = 1000

func _on_Player_body_entered(body):
	
	#print(body.get_class())
	#various cases
	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
		var relative_direction = body.linear_velocity - self.linear_velocity
		var damage =\
		chip_damage_collision + 15
		damage = clamp(damage,0,bound_on_external_damage)
		_sound_emiter(sound.collision,damage)
		_take_damage(damage)
		relative_direction = relative_direction.normalized()
		if !("player_index" in body):
			apply_central_impulse(-relative_direction*2*rebote)
		else:
			apply_central_impulse(relative_direction*rebote)
		
		
#	if body.get_class() == "RigidBody2D" and "damage_potential" in body:
#		var relative_velocity = self.linear_velocity - body.linear_velocity
#		var damage =\
#		chip_damage_collision +\
#		body.damage_potential* relative_velocity.length()
#		damage = clamp(damage,0,bound_on_external_damage)
#		_sound_emiter(sound.collision,damage)
#		_take_damage(damage)
#		#print(self.get_name() + "suffered: " + str(damage))
#		if "player_color" in body:
#			apply_central_impulse(-relative_velocity*rebote)
#		else: 
#			apply_central_impulse(linear_velocity*rebote)

#### Death
signal player_died
signal somewhat_out_of_bounds
signal out_of_bounds

var lower_bounds    = Vector2(0,0)
var upper_bounds    = Vector2(1920,1080)
var s_lower_bounds  = Vector2(100,100)
var s_upper_bounds  = Vector2(1820,980)

var death_time = 0.2
var already_death = false
func die():
	if already_death:
		return
	already_death = true
	emit_signal("player_died",player_index)
	_sound_emiter(sound.player_death,0)
	$DeathTimer.wait_time = death_time
	$DeathTimer.start()

func _really_die():
	get_parent().remove_child(self)

func _is_out_of_bounds():
	return !(\
	(position.x>=lower_bounds.x) and (position.x<=upper_bounds.x) and\
	(position.y>=lower_bounds.y) and (position.y<=upper_bounds.y))

func _is_somewhat_out_of_bounds():
	return !(\
	(position.x>=s_lower_bounds.x) and (position.x<=s_upper_bounds.x) and\
	(position.y>=s_lower_bounds.y) and (position.y<=s_upper_bounds.y))

## Sound
signal sfx_request

export (float,0,100,5) var minimum_volume = 90
enum sound {collision,player_death,chip_damage}
func _sound_emiter(type,strength):
	# strength tiene distintos valores dependiendo del origen
	# por simplicidad, strength vale de 0 a 100
	var type_string = ""
	var output = minimum_volume+strength*3/10
	match type:
		sound.collision:
			type_string = "player_collision"
		sound.player_death:
			type_string = "player_death"
		sound.chip_damage:
			output = strength
			type_string = "chip_damage"
	emit_signal("sfx_request",type_string,output)

## Scoring

signal score_growth #índice de jugador, cantidad
var _score_timer = 0
export (float,0,100) var time_to_score      = 1
export (int,  0,100) var score_per_interval = 1

func _score_counter(delta):
	if _health==0:
		return
	_score_timer+=delta
	
	if _score_timer>time_to_score:
		emit_signal("score_growth",player_index,score_per_interval)
		_score_timer = 0
