extends Node

var event_no = 0
var event_names = {0:"start",1:"woa"}
var debug = 0
var events_ended = false

func _ready():
	_launch_event()

func _launch_event():
	if events_ended:
		return
	
	# do launch some events
	var timer_follow_up = _event_launcher()
	
	if timer_follow_up == null:
		print("the event tree has been severed")
		push_warning("the event tree has been severed")
		return
	
	$customTimer.wait_time = timer_follow_up
	$customTimer.start()

func _its_timeout():
	event_no+=1
	if debug:
		pass
	
	_launch_event()

func external_event_changer(number):
	event_no = number
	$customTimer.stop()
	_its_timeout()

func _event_launcher():
	var time = null
	
	print("evento: "+str(event_no))
	
	match event_no:
		0:
			print("ready?")
			time = 2
		1:
			emit_signal("array_placed_asteroids",[-700,-300,300,700],0.3)
			time = 15
		2:
			emit_signal("simetric_random_asteroids",0.8)
			time = 5
		3:
			emit_signal("normal_random_asteroids",0.5)
			time = 5
		4:
			emit_signal("array_placed_asteroids",[-700,-300,300,700],1)
			time = 15
		5:
			emit_signal("simetric_random_asteroids",0.4)
			time = 15
		6:
			emit_signal("normal_random_asteroids",0.3)
			time = 15
		7:
			emit_signal("simetric_random_asteroids",0.3)
			time = 20
		_:
			_end_times()
	
	return time

func _end_times():
	events_ended = 1
	print("events_ended")
	
signal simetric_random_asteroids
signal normal_random_asteroids
# warning-ignore:unused_signal
signal place_asteroids
# warning-ignore:unused_signal
signal simetric_placed_asteroids
signal array_placed_asteroids
# warning-ignore:unused_signal
signal halt_asteroids
# warning-ignore:unused_signal
signal restart_asteroids
