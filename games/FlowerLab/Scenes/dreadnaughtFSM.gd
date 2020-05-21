extends "res://games/FlowerLab/Scripts/stateMachine.gd"

func _ready():
	add_state("launch_lasers")
	add_state("launch_bullets")
	add_state("prepare_beam")
	add_state("launch_lasers")

## Abstract functions ###################################
func _state_logic(delta):
	pass

func _get_transition(delta):
	pass

func _enter_state(new_state,old_state):
	pass

func _exit_state(old_state,new_state):
	pass
########################################################
