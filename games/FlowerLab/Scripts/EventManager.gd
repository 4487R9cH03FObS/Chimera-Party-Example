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

func _end_times():
	events_ended = 1
	print("events_ended")

func _event_launcher():
	var time = null
	print("evento: "+str(event_no))
	
	match event_no:
		0:
			print("ready?")
			time = 2
		1:
			if test_events:
				return _test_events()
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

var center = Vector2(1920/2,1080/2)
var top_center    = Vector2(1920/2,1080/2)

var test_events = 1
func _test_events():
	emit_signal("spawn_dreadnought",top_center)
	emit_signal("set_asteroid_speed",100)
	emit_signal("set_dreadnought_light_energy",1)
	emit_signal("start_dreadnought_lasers")
	#emit_signal("set_laser_pattern","type2",1,0.05,200) # type, pattern_time,laser_tme,speed
	emit_signal("set_dreadnought_scale",5)
	emit_signal("array_placed_asteroids",[-700,-300,300,700],1)
	_end_times()
	pass

signal set_asteroid_speed #speed
signal place_asteroids # position time
signal simetric_random_asteroids # time
signal simetric_placed_asteroids # time
signal normal_random_asteroids # time
signal array_placed_asteroids # array[position] time
signal halt_asteroids 
signal restart_asteroids

signal set_dreadnought_light_energy # float
signal set_dreadnought_scale # float 
signal spawn_dreadnought # position
signal delete_dreadnought
signal move_dreadnought_to # position
signal start_dreadnought_lasers
signal stop_dreadnought_lasers
signal set_laser_pattern # type, pattern_time,laser_tme,speed
signal set_laser_pattern_time #time
signal set_laser_time #time
signal set_laser_speed #speed

# laser types:
# nearest,everyone,farthest,type1,type2,type3,type4
