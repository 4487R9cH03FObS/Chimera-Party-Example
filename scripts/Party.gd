extends Node


var available_colors = [Color("9fbc4d"), Color("#bc4d4f"), Color("#fdc760"), Color("#4d92bc")]
var available_color_names = ["Verde", "Rojo", "Amarillo", "Azul"]

enum GameType {
	ALL_FOR_ALL = 1,
	ONE_VS_TWO = 2,
	ONE_VS_TREE = 4,
	TWO_VS_TWO = 8
}
var game_type = GameType.ALL_FOR_ALL
#var groups = [[0,1], [2,3]]
var groups = [[0, 1, 2, 3]]

# [{color, points}]
var _players: Array = [] setget , get_players

func load_test():
	_players = [{"color": -1, "points": 0},{"color": -1, "points": 0},\
	 {"color": -1, "points": 0}, {"color": 0, "points": 0}]

	# player 0
	_action_add_key("move_left_", 0, KEY_A)
	_action_add_key("move_right_", 0, KEY_D)
	_action_add_key("move_up_", 0, KEY_W)
	_action_add_key("move_down_", 0, KEY_S)
	_action_add_key("action_a_", 0, KEY_B)
	_action_add_key("action_b_", 0, KEY_N)
	
	#player 2
	_action_add_key("move_left_", 2, KEY_J)
	_action_add_key("move_right_", 2, KEY_L)
	_action_add_key("move_up_", 2, KEY_I)
	_action_add_key("move_down_", 2, KEY_K)
	_action_add_key("action_a_", 2, KEY_Z)
	_action_add_key("action_b_", 2, KEY_X)
	
	#player 3
	_action_add_key("move_left_", 3, KEY_LEFT)
	_action_add_key("move_right_", 3, KEY_RIGHT)
	_action_add_key("move_up_", 3, KEY_UP)
	_action_add_key("move_down_", 3, KEY_DOWN)
	_action_add_key("action_a_", 3, KEY_C)
	_action_add_key("action_b_", 3, KEY_V)

func get_players():
	return _players

# [0, 50, 0, 100]
func end_game(points):
	for i in range(_players.size()):
		_players[i].points += points[i]
	print("Game Finished")
	print(points)

func get_color_name(index):
	return available_color_names[index]

func _action_add_key(action, player_index: int, key):
	var ike: InputEventKey
	ike = InputEventKey.new()
	ike.scancode = key
	InputMap.action_add_event(action + str(player_index), ike)
	
