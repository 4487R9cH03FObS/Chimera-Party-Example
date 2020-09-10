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
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P1"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P2"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P3"),\
get_node("MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P4")]
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

onready var player_score_nodes = ([
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P1/ColorRect,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P2/ColorRect,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P3/ColorRect,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P4/ColorRect])

func _on_player_death(i):
	#var col = player_score_nodes[i].modulate
	player_score_nodes[i].modulate = Color.red #  col.lerp(col,Color.red,0)
	
	pass

onready var message_label=$MarginContainer/HBoxContainer/VBoxContainer3/gameplay/scoreLabel


signal freeze_timer
func on_ending(player,winner):
	emit_signal("freeze_timer")
	var message = "\n\n\n"
	message+=player
	message+="\n"
	message+="[rainbow]"+ winner +" !!![/rainbow] [wave amp=50 freq=2] WINNER [/wave]"
	message_label.set_bbcode(message)
	message_label.visible = true

func _on_display_message(message):
	message_label.bbcode_text=message
	message_label.visible=true
	pass

func _on_hide_message():
	message_label.visible=false

func _pulse_everyone():
	for node in pulsating_nodes:
		node.color = target_color

onready var score_nodes =[\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P1/ColorRect/RichTextLabel,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P2/ColorRect/RichTextLabel,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P3/ColorRect/RichTextLabel,\
$MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/P4/ColorRect/RichTextLabel]

func _change_score(index,score):
	var node = null
	match index:
		0:
			node = score_nodes[0]
		1:
			node = score_nodes[1]
		2:
			node = score_nodes[2]
		3:
			node = score_nodes[3]
	if node==null:
		return
	node.text = "P"+str(index+1)+":  "+str(score)
