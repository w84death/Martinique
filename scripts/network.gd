extends Node

const SERVER_IP = '192.168.1.104'
const DEFAULT_PORT = 31416
const MAX_PEERS    = 10
var   players      = {}
var   player_name

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
	
func start_server():
	player_name = 'Server'
	var host    = NetworkedMultiplayerENet.new()
	
	var err = host.create_server(DEFAULT_PORT, MAX_PEERS)
	
	if (err!=OK):
		join_server()
		return
		
	get_tree().set_network_peer(host)
	
	spawn_player(1)
	update_player_list()
	print("Server started!")
	
func join_server():
	player_name = 'Client'
	var host    = NetworkedMultiplayerENet.new()
	
	host.create_client(SERVER_IP, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	print("Joined to server!")
	update_player_list()
	
func _player_connected(id):
	print("Player connected [" + str(id) + "]")
	update_player_list()
	
func _player_disconnected(id):
	unregister_player(id)
	rpc("unregister_player", id)
	print("Player disconected [" + str(id) + "]")
	update_player_list()
	
func update_player_list():
	print(players)
	get_node("../p1x/players").clear()
	get_node("../p1x/players").add_text("PLAYERS:")
	get_node("../p1x/players").newline()
	for p in players:
		print(players[p])
		get_node("../p1x/players").add_text(str(players[p]))
		get_node("../p1x/players").newline()
		
func _connected_ok():
	rpc_id(1, "user_ready", get_tree().get_network_unique_id(), player_name)
	
remote func user_ready(id, player_name):
	if get_tree().is_network_server():
		rpc_id(id, "register_in_game")
		
remote func register_in_game():
	rpc("register_new_player", get_tree().get_network_unique_id(), player_name)
	register_new_player(get_tree().get_network_unique_id(), player_name)
	update_player_list()
	
func _server_disconnected():
	quit_game()
	
remote func register_new_player(id, name):
	if get_tree().is_network_server():
		rpc_id(id, "register_new_player", 1, player_name)
		print("Pregister_new_player [" + str(id) + "]")
		for peer_id in players:
			rpc_id(id, "register_new_player", peer_id, players[peer_id])
			
	players[id] = name
	spawn_player(id)
	
remote func register_player(id, name):
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, player_name)
		
		for peer_id in players:
			rpc_id(id, "register_player", peer_id, players[peer_id])
			rpc_id(peer_id, "register_player", id, name)
			
	players[id] = name
	update_player_list()

remote func unregister_player(id):
	get_node("../terrain/" + str(id)).queue_free()
	get_node("../terrain/").remove_child(str(id))
	players.erase(id)
	update_player_list()
	
func quit_game():
	get_tree().set_network_peer(null)
	players.clear()
	
func spawn_player(id):
	var player_scene = load("res://playe_p2p.tscn")
	var player       = player_scene.instance()
	
	player.set_name(str(id))
	
	if id == get_tree().get_network_unique_id():
		player.set_network_master(id)
		
		player.player_id = id
		player.control   = true
		
	get_node("../terrain").add_child(player)