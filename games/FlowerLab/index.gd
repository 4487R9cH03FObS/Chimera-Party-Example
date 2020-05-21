extends Node2D

var Player = preload("res://games/FlowerLab/Scenes/Player.tscn")

onready var Players = $Players
var players

onready var gameplay_screen = get_node("GUI/MarginContainer/HBoxContainer/VBoxContainer3/gameplay")

func _ready():
	Party.load_test()
	players = Party.get_players()
	for i in range(players.size()):
		if players[i].color != -1:
			var player_inst = Player.instance()
			$Players.add_child(player_inst)
			player_inst.init(i, players[i].color)
	var player_num = Players.get_child_count()
	for i in range(player_num):
		Players.get_child(i).global_position = \
			$Positions.get_child(i).global_position
	
	$Timer.connect("timeout", self, "on_timeout")
	

func on_timeout():
	$CanvasLayer/Label.visible = true
	Party.end_game([100, 0, 50, 0])
	
func _physics_process(delta):
	var players = Players.get_children()
	players.sort_custom(self, "sort_by_y")
	for i in range(players.size()):
		players[i].z_index = i

func sort_by_y(a, b):
	return a.position.y < b.position.y
