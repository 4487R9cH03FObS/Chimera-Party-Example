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
	
	match event_no:
		0:
			print("ready??")
			time = 10
		1:
			print("initial asteroid belt")
			emit_signal("simetric_random_asteroids")
			time = 10
		2:
			print("second asteroid belt")
			emit_signal("normal_random_asteroids")
			time = 30
		_: 
			_end_times()
	
	return time

func _end_times():
	events_ended = 1
	print("events_ended")

# warning-ignore:unused_signal
signal simetric_random_asteroids
signal normal_random_asteroids
signal event3
# warning-ignore:unused_signal
signal event4
# warning-ignore:unused_signal
signal event5
# warning-ignore:unused_signal
signal event6
# warning-ignore:unused_signal
signal event7
# warning-ignore:unused_signal
signal event8
# warning-ignore:unused_signal
signal event9
# warning-ignore:unused_signal
signal event10
