extends Sprite

export (float,0,6.28) var phase            = -3.14
export (int,0,10000) var amplitude         = 1600
export (float,0,1,0.0001) var angular_speed = 0.005
var t = 0
var angle = 0

var original_position

func _ready():
	position += 2*Vector2(amplitude,0)
	original_position = position

func _physics_process(delta):
	
	t+=delta
	angle = 2*PI*angular_speed*t+phase
	position = original_position +\
	 amplitude*Vector2(cos(angle) -1,sin(angle))
	if angle>2*PI:
		t=0
