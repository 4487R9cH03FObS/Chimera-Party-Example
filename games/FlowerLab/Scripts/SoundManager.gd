extends Node

onready var sfx   = $SFx
onready var music = $Music 
onready var env   = $Environment

func _on_sfx_request(name,volume):
	volume = _transform_to_db(volume)
	match name:
		"player_collision":
			print("choque jugador")
			$SFX/playerCollision.volume_db = volume
			$SFX/playerCollision.play()

func _transform_to_db(volume):
	return -clamp(100-volume,0,100)

enum environments {start,first_phase,second_phase,third_phase,finish}
var _current_environment = environments.start

func _auto_play_environment():
	# si se ha invocado es porque la música terminó
	match _current_environment:
		environments.start:
			$Environment/VacuumStart.play()

func _ready():
	_auto_play_environment()
