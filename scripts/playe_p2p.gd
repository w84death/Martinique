extends Node

var player_id
var control

func _ready():
	randomize()

func _process(delta):
	if Input.is_key_pressed(KEY_M):
		rpc_unreliable("say_hello", "hello!!!!", player_id)
	
	if Input.is_key_pressed(KEY_R):
		var position = Vector3(-1 + randf() * 2, 0, -1 + randf() * 2)
		rpc_unreliable("do_move", position, player_id)
		do_move(position, player_id)
		
remote func say_hello(msg, pid):
	if pid == player_id: pass
	print(str(pid) + ": " + msg)
	
remote func do_move(position, pid):
	var root  = get_parent()
	var pnode = root.get_node(str(pid))
	
	pnode.get_node("body").translate(position)