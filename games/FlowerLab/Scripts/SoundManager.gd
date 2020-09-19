extends Node

onready var sfx   = $SFX
onready var music = $Music 
onready var env   = $Environment

func _on_sfx_request(name,volume):
	volume = _transform_to_db(volume)
	match name:
		"player_collision":
			#print("choque jugador")
			$SFX/playerCollision.volume_db = volume
			$SFX/playerCollision.play()
		"player_death":
			$SFX/playerDeath.volume_db = volume
			$SFX/playerDeath.play()
			$SFX/playerDeath.volume_db = volume
			$SFX/playerDeath.play()
		"chip_damage":
			$SFX/chipDamage.volume_db = volume
			$SFX/chipDamage.play()
			pass

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

func _on_all_players_died(variable):
	_stop_gameplay_music()
	$Timer.start()

export var db_scores = -10
func _on_Timer_timeout():	
	$Music/gameplayMusic.set_stream_paused(false)
	#_play_score_music()
	$Music/gameplayMusic.set_volume_db(db_scores)

func _play_gameplay_music():
	$Music/gameplayMusic.play()

func _stop_gameplay_music():
	$Music/gameplayMusic.set_stream_paused(true)

func _play_score_music():
	$Music/scoreMusic.play()

func _stop_score_music():
	$Music/scoreMusic.stop()

func _on_gameplayMusic_finished():
	_play_gameplay_music()
