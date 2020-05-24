extends Control

func _ready():
	timer.wait_time = alarm_wait
	pass

onready var pulsating_nodes  = [\
get_node("MarginContainer/HBoxContainer/VBoxContainer/centIzq"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer2/centDer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer/supIzq"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/supCent"),\

get_node("MarginContainer/HBoxContainer/VBoxContainer2/supDer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer/infIzq"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer2/infDer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/FirstPlayer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/SecondPlayer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/ThirdPlayer"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/FourthPlayer")]
#get_node("MarginContainer/HBoxContainer/VBoxContainer3/infCent"),\

onready var timer = $pulse_timer

var player_gui_nodes = {0:"",1:"",2:"",3:""}
var pulsating = false

var pulse_color = Color.red.linear_interpolate(Color.black,0.5)
var base_color  = Color.black
onready var target_color = base_color

func _on_pulse():
	if pulsating:
		return
	pulsating = true
	_pulse_everyone()
	timer.start()

var alarm_wait = 0.3
export (float,0,1,0.05) var alarm_speed
# warning-ignore:unused_argument
func _physics_process(delta):
	if pulsating:
		target_color = target_color.linear_interpolate(pulse_color,alarm_speed)
		_pulse_everyone()
		pass

func _on_end_pulse():
	target_color = base_color
	_pulse_everyone()
	pulsating = false

func _on_player_death(i):
	
	pass

func _pulse_everyone():
	for node in pulsating_nodes:
		node.color = target_color
